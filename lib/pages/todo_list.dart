import 'package:flutter/material.dart';
import 'package:sign_in_with_google/pages/loading.dart';
import 'package:sign_in_with_google/model/todo.dart';
import 'package:sign_in_with_google/services/database_services.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool isComplet = false; // just for now
  TextEditingController todoTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(children: [
        Image.asset(
        "assets/clip-996.png",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
        ),
      Scaffold(
        body: SafeArea(
          child: StreamBuilder<List<Todo>>(
              stream: DatabaseService().listTodos(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Loading();
                }
                List<Todo>? todos = snapshot.data;
                return Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "All Todos",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color: Colors.grey[600],
                      ),
                      SizedBox(height: 20),
                      ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[800],
                        ),
                        shrinkWrap: true,
                        itemCount: todos == null ? 0 : todos.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: UniqueKey(),
                            background: Container(
                              padding: const EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                              child: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                            onDismissed: (direction) async {
                              await DatabaseService()
                                  .removeTodo(todos![index].uid);
                              //
                            },
                            child: ListTile(
                              onTap: () {
                                DatabaseService()
                                    .completTask(todos![index].uid);
                              },
                              leading: Container(
                                padding: const EdgeInsets.all(2),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: todos![index].isComplet
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : Container(),
                              ),
                              title: Text(
                                todos[index].title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                );
              }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                // child: SimpleDialog(
                //   contentPadding: EdgeInsets.symmetric(
                //     horizontal: 25,
                //     vertical: 20,
                //   ),
                backgroundColor: Colors.grey[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    const Text(
                      "Add Todo",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.grey,
                        size: 30,
                      ),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                children: [
                  Divider(),
                  TextFormField(
                    controller: todoTitleController,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      color: Colors.white,
                    ),
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: "eg. Water the plants",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: width,
                    height: 50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text("Add"),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (todoTitleController.text.isNotEmpty) {
                          await DatabaseService()
                              .createNewTodo(todoTitleController.text.trim());
                          Navigator.pop(context);
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      )
    ]);
  }
}
