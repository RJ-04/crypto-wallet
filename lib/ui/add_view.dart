import 'package:crypto_wallet/net/flutter_fire.dart';
import 'package:crypto_wallet/utils/show_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'home_view.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  List<String> coins = [
    "bitcoin",
    "tether",
    "ethereum",
    "dogecoin",
    "tron",
  ];

  String dropdownValue = "bitcoin";
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hght = MediaQuery.of(context).size.height;
    var len = MediaQuery.of(context).size.longestSide;

    PreferredSize appBar = PreferredSize(
      preferredSize: Size.fromHeight(len * 0.07),
      child: AppBar(backgroundColor: Colors.amber),
    );

    return Scaffold(
      appBar: appBar,
      body: Material(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(hght * 0.1),
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton(
                  value: dropdownValue,
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: coins.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Expanded(
                  flex: 0,
                  child: SizedBox(
                    height: hght / 5,
                  ),
                ),
                Container(
                  constraints:
                      const BoxConstraints(minWidth: 285, maxWidth: 315),
                  child: TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: "Coin amount",
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 0, style: BorderStyle.none),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      fillColor: const Color.fromARGB(255, 226, 216, 216),
                      filled: true,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: SizedBox(
                    height: hght / 50,
                  ),
                ),
                Container(
                  constraints:
                      const BoxConstraints(minWidth: 285, maxWidth: 315),
                  height: 50,
                  child: MaterialButton(
                    splashColor: const Color.fromARGB(255, 2, 243, 10),
                    hoverColor: const Color.fromARGB(206, 230, 226, 226),
                    onPressed: () async {
                      String addingCoin = "unknown";

                      kIsWeb
                          ? showCupertinoDialog(
                              useRootNavigator: true,
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    top: appBar.preferredSize.height * 1.1,
                                    bottom: hght -
                                        appBar.preferredSize.height * 1.2,
                                  ),
                                  child: const LinearProgressIndicator(
                                    color: Color.fromARGB(255, 0, 225, 255),
                                    backgroundColor: Colors.grey,
                                  ),
                                );
                              },
                            )
                          : showCupertinoDialog(
                              useRootNavigator: true,
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    top: appBar.preferredSize.height * 1.6,
                                    bottom: hght -
                                        appBar.preferredSize.height * 1.7,
                                  ),
                                  child: const LinearProgressIndicator(
                                    color: Color.fromARGB(255, 0, 225, 255),
                                    backgroundColor: Colors.grey,
                                  ),
                                );
                              },
                            );

                      addingCoin =
                          await addCoin(dropdownValue, _amountController.text);

                      if (addingCoin == "true") {
                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeView(),
                          ),
                          (Route<dynamic> route) => false,
                        );

                        // ignore: use_build_context_synchronously
                        showSnackBar(context,
                            "${_amountController.text} added to ${dropdownValue.toString()}");
                      } else if (addingCoin != "unknown") {
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);

                        // ignore: use_build_context_synchronously
                        showSnackBar(context, addingCoin);
                      }
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(color: Color.fromARGB(255, 255, 0, 170)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
