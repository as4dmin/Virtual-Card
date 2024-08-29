import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vcard1/models/contact_model.dart';
import 'package:vcard1/provider/contact_provider.dart';
import 'package:vcard1/utils/helper_function.dart';

class ContactDetailsPage extends StatefulWidget {
  static const String routeName = 'details';
  final int id;
  const ContactDetailsPage({super.key, required this.id});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  late int id;
  @override
  void initState() {
    id = widget.id;
    print(id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => FutureBuilder<ContactModel>(
          future: provider.getContactById(id),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              final contact = snapshot.data!;
              return ListView(
            padding: EdgeInsets.all(8),
            children: [
              Image.file(File(contact.image), 
                width: double.infinity,  
                height: 250,
                fit: BoxFit.cover,
              ),
              ListTile(
                title: Text(contact.mobile),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        callContact(contact.mobile);
                      }, 
                      icon: const Icon(Icons.call)
                      ),
                    IconButton(
                      onPressed: () {
                        smsContact(contact.mobile);
                      }, 
                      icon: const Icon(Icons.sms)
                      ),
                  ],
                ),
              )
            ],
            );
            }
            if(snapshot.hasError){
              return const Center(
                child: Text('Failed to load data'),
              );
            }
            return const Center(child: Text("Failed to load data"),);
          }
        ),
      ),
    );
  }
  
  void callContact(String mobile) async {
    final url = 'tel:$mobile';
    if(await canLaunchUrlString(url)){
      await launchUrlString(url);
    } else{
      showMsg(context, 'Can not perform this process');
    }
  }

  void smsContact(String mobile) async {
    final url = 'sms:$mobile';
    if(await canLaunchUrlString(url)){
      await launchUrlString(url);
    }else{
      showMsg(context, 'Cannot perform this procsee');
    }
  }
}