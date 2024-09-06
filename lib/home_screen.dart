import 'package:flutter/material.dart';
import 'package:todo_app/add_update_screen.dart';
import 'package:todo_app/db_handler.dart';
import 'package:todo_app/mode.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;

  late Future<List<TodoModel>> dataList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  _onEdit(int todoId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AddUpdateTask(
                  todoId: todoId,
                  // todoTitle: todoTitle,
                  // todoDesc: todoDesc,
                  // todoDT: todoDT,
                  update: true,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text(
          'DP-TODO',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 1),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.help_outline_rounded,
              size: 30,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                  future: dataList,
                  builder: (context, AsyncSnapshot<List<TodoModel>> snapShot) {
                    if (!snapShot.hasData || snapShot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapShot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "No task found",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapShot.data!.length,
                        itemBuilder: (context, index) {
                          TodoModel todo = snapShot.data![index];
                          int todoId = todo.id!;
                          String todoTitle = todo.title!;
                          String todoDesc = todo.desc!;
                          String todoDT = todo.dateAndTime!;

                          return Dismissible(
                            key: ValueKey<int>(todoId),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              child: Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (DismissDirection direction) {
                              setState(() {
                                dbHelper!.delete(todoId);
                                dataList = dbHelper!.getDataList();
                                snapShot.data!.remove(snapShot.data![index]);
                              });
                            },
                            child: InkWell(
                              onTap: () => _onEdit(todoId),
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.yellow.shade300,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          spreadRadius: 1)
                                    ]),
                                child: Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10),
                                      title: Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          todoTitle,
                                          style: TextStyle(fontSize: 19),
                                        ),
                                      ),
                                      subtitle: Text(
                                        todoDesc,
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.black,
                                      thickness: 0.8,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            todoDT,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.italic),
                                          ),
                                          InkWell(
                                            onTap: () => _onEdit(todoId),
                                            child: Icon(
                                              Icons.edit_note,
                                              size: 28,
                                              color: Colors.green,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      // return Placeholder();
                    }
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddUpdateTask()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
