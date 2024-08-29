import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vcard1/pages/contact_details_page.dart';
import 'package:vcard1/pages/scanpage.dart';
import 'package:vcard1/provider/contact_provider.dart';
import 'package:vcard1/utils/helper_function.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int seletedIndex = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    Provider.of<ContactProvider>(context, listen: false).getAllContacts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.goNamed(ScanPage.routeName);
        },
        shape:const  CircleBorder(),
        child:const Icon(Icons.add),
        ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(8),
        shape:const  CircularNotchedRectangle(),
        notchMargin: 18,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          backgroundColor:const  Color.fromARGB(255, 175, 158, 244),
          onTap: (index) {
            setState(() {
              seletedIndex = index;
            });
            _fetchData();
          },
          currentIndex: seletedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'All'
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favroite'
              ),
          ],
          ),
      ),
      appBar: AppBar(
        title:const Text('Home Page'),
        backgroundColor:const  Color.fromARGB(255, 135, 140, 244),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.contactList.length,
          itemBuilder: (context, index ){
            final contact = provider.contactList[index];
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                padding: const EdgeInsets.only(right: 20),
                alignment: FractionalOffset.centerRight,
                color: Colors.red,
                child: const Icon(Icons.delete,size: 25,color: Colors.white,),
              ),
              confirmDismiss: _showConfirmationDialog,
              onDismissed: (_) async {
                await provider.deleteContact(contact.id);
                showMsg(context, 'DELETE'); 
              },

              child: ListTile(
                onTap: () => context.goNamed(ContactDetailsPage.routeName, extra: contact.id),
                title: Text(contact.name),
                trailing: IconButton(
                  onPressed: (){
                    provider.updateFavorite(contact);
                  },
                  icon: Icon(contact.favorite ? Icons.favorite : Icons.favorite_border),
                ),
              ),
            );
          }
          ),
        ),
    );
  }

  Future<bool?> _showConfirmationDialog(DismissDirection direction) {
    return showDialog(
      context: context, 
      builder: (context) =>  AlertDialog(
        title: const Text('Delete Contact'),
        content: const Text("Are you sure to delete this contact?"),
        actions: [
          OutlinedButton(
            onPressed: (){
              context.pop(false);
            }, 
          child: const Text('NO'),
          ),
          OutlinedButton(
            onPressed: (){
              context.pop(true);
            }, 
          child: const Text('YES'),
          ),
        ],
      ),
      );
  }
  
  void _fetchData() {
    switch(seletedIndex){
      case 0:
        Provider.of<ContactProvider>(context, listen: false).getAllContacts();
        break;
      case 1:
        Provider.of<ContactProvider>(context, listen: false).getAllFavoriteContacts();
        break;
    }
  }
}