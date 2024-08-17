import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application/cubit/profile_cubit_cubit.dart';
import '../domain/user_model.dart';
import 'widgets/detail_item.dart';

class ViewProfile extends StatefulWidget {
  final UserModel userModel;

  const ViewProfile({super.key, required this.userModel});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  void initState() {
    context.read<ProfileCubit>().fetchUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile Detail'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.grey[200],
                child: widget.userModel.profileImageUrl == null ||
                        widget.userModel.profileImageUrl!.isEmpty
                    ? Text(
                        widget.userModel.name.characters.first.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: widget.userModel.profileImageUrl!,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Text(
                          widget.userModel.name.characters.first.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 50.0,
                          backgroundImage: imageProvider,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20.0),
            DetailItem(label: 'Name ', value: widget.userModel.name),
            DetailItem(label: 'Email', value: widget.userModel.email),
            DetailItem(label: 'Address', value: widget.userModel.location),
          ],
        ),
      ),
    );
  }
}
