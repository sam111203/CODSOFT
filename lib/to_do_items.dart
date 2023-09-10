import 'package:flutter/material.dart';

class ToDoItem extends StatefulWidget {
  ToDoItem({
    Key? key,
    required this.title,
    required this.onDelete,
    required this.onUpdateTitle,
    required this.isChecked,
    this.priority,
  }) : super(key: key);

  final String title;
  final VoidCallback onDelete;
  final Function(String, bool) onUpdateTitle;
  final bool isChecked;
  String? priority; // Remove final

  @override
  _ToDoItemState createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 23, bottom: 6),
      child: ListTile(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: Text('Choose Priority of Task'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    // Handle High Priority
                    Navigator.pop(context, 'High Priority');
                  },
                  child: Text('1 - High'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    // Handle Medium Priority
                    Navigator.pop(context, 'Medium Priority');
                  },
                  child: Text('2 - Medium'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    // Handle Low Priority
                    Navigator.pop(context, 'Low Priority');
                  },
                  child: Text('3 - Low'),
                ),
              ],
            ),
          ).then((value) {
            // Handle the result from the dialog (which option was chosen).
            if (value != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('You selected: $value'),
                ),
              );
              // Update the priority when an option is chosen
              setState(() {
                widget.priority = value.toString();
              });
            }
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.white,
        leading: Checkbox(
          value: isChecked,
          onChanged: (newValue) {
            setState(() {
              isChecked = newValue ?? false;
              widget.onUpdateTitle(widget.title, isChecked);
            });
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Are you sure you want to continue?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      isChecked = false;
                      widget.onUpdateTitle(widget.title, isChecked);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
          activeColor: Colors.green,
        ),
        title: Text(
          widget.title,
          style: isChecked
              ? TextStyle(
            decoration: TextDecoration.lineThrough,
          )
              : TextStyle(),
        ),
        trailing: Container(
          height: 35,
          width: MediaQuery.of(context).size.width * 0.3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                color: Colors.black,
                iconSize: 18,
                icon: Icon(Icons.edit),
                onPressed: () {
                  TextEditingController _editedController =
                  TextEditingController(text: widget.title);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Edit Task'),
                      content: TextField(
                        controller: _editedController,
                        decoration: InputDecoration(hintText: 'Edit task...'),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Save'),
                          onPressed: () {
                            String newTitle = _editedController.text;
                            widget.onUpdateTitle(newTitle, isChecked);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              IconButton(
                color: Colors.red,
                iconSize: 18,
                icon: Icon(Icons.delete),
                onPressed: widget.onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
