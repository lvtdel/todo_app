import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/db_handler.dart';
import 'package:todo_app/home_screen.dart';
import 'package:todo_app/mode.dart';

class AddUpdateTask extends StatefulWidget {
  int? todoId;
  // String? todoTitle;
  // String? todoDesc;
  // String? todoDT;
  bool? update;

  AddUpdateTask(
      {super.key,
      this.todoId,
      // this.todoTitle,
      // this.todoDesc,
      // this.todoDT,
      this.update});

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  _onSubmit(BuildContext context) {
    var todoBloc = context.read<TodoBloc>();
    String title = titleController.text;
    String desc = descController.text;

    if (_formKey.currentState!.validate()) {
      if (widget.update == true) {
        TodoLoadedState todoLoadedState = todoBloc.state as TodoLoadedState;

        todoBloc.add(UpdateTodoEvent(
            id: todoLoadedState.todoModel.id!,
            title: title,
            desc: desc,
            dateAndTime: todoLoadedState.todoModel.dateAndTime));
      } else {
        todoBloc.add(AddTodoEvent(title: title, desc: desc));
      }
      // Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      Navigator.pop(context);
      titleController.clear();
      descController.clear();
    }
  }

  _onEdit() {

  }

  _onClear() {
    titleController.clear();
    descController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // final titleController = TextEditingController(text: widget.todoTitle);
    // final descController = TextEditingController(text: widget.todoDesc);

    String appTitle = widget.update == true ? "Update Task" : "Add Task";

    return BlocProvider(
      create: (_) {
        var bloc = TodoBloc();
        if (widget.update == true) {
          print("Add LoadEvent");
          bloc.add(LoadTodoEvent(id: widget.todoId!));
        }
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appTitle,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 1),
          ),
          centerTitle: true,
          elevation: 0,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.help_outline_rounded,
                size: 30,
              ),
            )
          ],
        ),
        body: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state is TodoLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TodoLoadedState) {
              titleController.text = state.todoModel.title ?? "";
              descController.text = state.todoModel.desc ?? "";
            }
            print(state);
            // if (state is TodoInitial){
              return Padding(
                padding: EdgeInsets.only(top: 100),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  controller: titleController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Note Title",
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter some text";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  controller: descController,
                                  maxLines: null,
                                  minLines: 5,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Write notes here",
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter some text";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Material(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: () {
                                  _onSubmit(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 55,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    // boxShadow: [BoxShadow(
                                    //   color: Colors.black12,
                                    //   blurRadius: 5,
                                    //   spreadRadius:1
                                    // )]
                                  ),
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.red[400],
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: _onClear,
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 55,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    // boxShadow: [BoxShadow(
                                    //   color: Colors.black12,
                                    //   blurRadius: 5,
                                    //   spreadRadius:1
                                    // )]
                                  ),
                                  child: Text(
                                    "Clear",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
          },
        ),
      ),
    );
  }

  void loadData() async {
    dataList = dbHelper!.getDataList();
  }
}
