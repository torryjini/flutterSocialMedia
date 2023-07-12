import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/components/comment.dart';
import 'package:socialmedia/components/comment_button.dart';
import 'package:socialmedia/components/delete_button.dart';
import 'package:socialmedia/components/like_button.dart';
import 'package:socialmedia/helper/helper_methods.dart';

class WallPost extends StatefulWidget {
  final String message, user, postId, time;
  final List<String> likes;

  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  //comment text controller
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  //toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection("User posts").doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  // add a comment
  void addComment(String commentText) {
    // write the comment to firestore under the comments collection for this post
    FirebaseFirestore.instance
        .collection("User posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now(),
    });
  }

  // show a dialog box for adding comment
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(hintText: "Write a comment.."),
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: const Text("Cancel"),
          ),
          // save button
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: const Text("Post"),
          ),
        ],
      ),
    );
  }

  void deletePost() {
    // show dialog box
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete this post?"),
        actions: [
          // CANCEL BUTTON
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          // DELETE BUTTON
          TextButton(
              onPressed: () async {
                final commentDocs = await FirebaseFirestore.instance
                    .collection("User posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .get();
                // Delete the comments in the post
                for (var comment in commentDocs.docs) {
                  await FirebaseFirestore.instance
                      .collection("User posts")
                      .doc(widget.postId)
                      .collection("Comments")
                      .doc(comment.id)
                      .delete();
                }

                FirebaseFirestore.instance
                    .collection("User posts")
                    .doc(widget.postId)
                    .delete()
                    .then((value) => print("Post deleted"))
                    .catchError(
                        (error) => print("Failed to delete post: $error"));

                //Dismiss the dialog
                Navigator.pop(context);
              },
              child: const Text("Delete")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(
        top: 25,
        left: 25,
        right: 25,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          //User
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // profile pic
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[400],
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.person),
              ),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        " · ",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.message),
                ],
              ),
              //delete button
              if (widget.user == currentUser.email)
                DeleteButton(
                  onTap: deletePost,
                )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  CommentButton(onTap: showCommentDialog),
                  const SizedBox(
                    height: 5,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("User posts")
                        .doc(widget.postId)
                        .collection("Comments")
                        .snapshots(),
                    builder: (context, snapshot) {
                      //show loading circle if no data yet
                      if (!snapshot.hasData) {
                        return const Text(
                          "0",
                        );
                      }
                      return Text(
                        snapshot.data!.docs.length.toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          // comments under the post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              //show loading circle if no data yet
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map(
                  (doc) {
                    //get the comment
                    final commentData = doc.data() as Map<String, dynamic>;
                    // return the comment
                    return Comment(
                      text: commentData["CommentText"],
                      user: commentData["CommentedBy"],
                      time: formatDate(commentData["CommentTime"]),
                    );
                  },
                ).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
