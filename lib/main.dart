// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var employeeApi =
        DefaultAssetBundle.of(context).loadString('assets/api/my_api.json');

    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App with API'),
        ),
        body: FutureBuilder(
          future: employeeApi,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Text('Data not found');
            }
            var employees = json.decode(snapshot.data.toString());
            List employeeList = employees['employees'];
            Set departments =
                employeeList.map((employee) => employee['department']).toSet();

            List employeeEachDepartment = departments.map((department) {
              return employeeList
                  .where((employee) => employee['department'] == department)
                  .toList();
            }).toList();

            return DefaultTabController(
              child: Column(
                children: [
                  TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Colors.blue[700],
                      labelColor: Colors.blue[700],
                      isScrollable: true,
                      labelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GoogleSans',
                      ),
                      unselectedLabelColor: Colors.grey[600],
                      tabs: departments.map((department) {
                        return Tab(
                          text: department,
                        );
                      }).toList()),
                  Expanded(
                      child: TabBarView(
                    children: employeeEachDepartment.map((employee) {
                      return ListView.builder(
                          itemCount: employee.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                child: ListTile(
                              title: Text(employee[index]['firstName'] +
                                  ' ' +
                                  employee[index]['lastName']),
                              subtitle: Text(employee[index]['skills']
                                  .toString()
                                  .replaceAll('[', '')
                                  .replaceAll(']', '')),
                              trailing: Text(
                                  "\$${employee[index]['salary'].toString()}"),
                            ));
                          });
                    }).toList(),
                  )),
                ],
              ),
              length: departments.length,
            );
          },
        ),
      ),
    );
  }
}
