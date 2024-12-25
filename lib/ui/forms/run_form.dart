import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:runninglog/model/shoe.dart';
import 'package:runninglog/providers/firestore_holder.dart';
import 'package:runninglog/ui/runs.dart';

class RunCreationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Run'),
      ),
      body: RunCreationForm(),
    );
  }
}

class RunCreationForm extends StatefulWidget {
  @override
  _RunCreationFormState createState() => _RunCreationFormState();
}

class _RunCreationFormState extends State<RunCreationForm> {
  DateTime date = DateTime.now();
  TextEditingController distance = TextEditingController();
  TextEditingController duration = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String shoes;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM dd yyyy');
    final data = FirestoreHolder.of(context, listen: false);
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Date'),
              trailing: Text(formatter.format(date)),
              onTap: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(date.year),
                  lastDate: DateTime(date.year, 12, 1),
                );
                if (selected == null) return;
                setState(() {
                  date = selected;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: distance,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Distance',
              ),
              validator: (value) {
                if (double.tryParse(value) == null) {
                  return 'Must be a valid distance';
                }
                return null;
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: duration,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Duration',
              ),
              validator: (value) {
                if (int.tryParse(value) == null) {
                  return 'Must be a valid integer';
                }
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            StreamBuilder<List<Shoe>>(
              stream: data.shoes,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('Loading Shoes');
                }
                final items = snapshot.data
                    .map(
                      (e) => DropdownMenuItem<Shoe>(
                        child: Text(e.name),
                        value: e,
                      ),
                    )
                    .toList();
                return DropdownButtonFormField<Shoe>(
                  validator: (shoe) {
                    if (shoe == null) return 'Shoes are required';
                    return null;
                  },
                  hint: Text('Shoes used'),
                  items: items,
                  onChanged: (shoe) {
                    setState(() {
                      this.shoes = shoe.path;
                    });
                  },
                );
              },
            ),
            FlatButton(
              onPressed: () async {
                final FormState form = _formKey.currentState;
                if (form.validate() && shoes != null) {
                  form.save();
                  final database = FirestoreHolder.of(context, listen: false);
                  final future = database.createRun(
                    date: date,
                    distance: double.parse(distance.text),
                    duration: int.parse(duration.text),
                    shoePath: shoes,
                  );
                  future.then((_) => Navigator.of(context).pop()).catchError((_) {});
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
