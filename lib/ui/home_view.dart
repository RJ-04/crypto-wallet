import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/net/api_method.dart';
import 'package:crypto_wallet/net/flutter_fire.dart';
import 'package:crypto_wallet/utils/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'add_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double bitcoin = 0.0;
  double ethereum = 0.0;
  double tether = 0.0;
  double dogecoin = 0.0;
  double tron = 0.0;
  bool _delete = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getValues();
  }

  void getValues() async {
    setState(() {
      _isLoading = true;
    });

    bitcoin = await getPrice("bitcoin");
    ethereum = await getPrice("ethereum");
    tether = await getPrice("tether");

    dogecoin = await getPrice("dogecoin");
    tron = await getPrice("tron");

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double getValues(String id, double amount) {
      if (id == "bitcoin") {
        return bitcoin * amount;
      } else if (id == "ethereum") {
        return ethereum * amount;
      } else if (id == "tether") {
        return tether * amount;
      } else if (id == "dogecoin") {
        return dogecoin * amount;
      } else {
        return tron * amount;
      }
    }

    var hght = MediaQuery.of(context).size.height;
    var wdth = MediaQuery.of(context).size.width;

    PreferredSize appBar = PreferredSize(
      preferredSize: Size.fromHeight(hght * 0.06),
      child: AppBar(backgroundColor: Colors.amber),
    );

    return _isLoading
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.amber,
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: LinearProgressIndicator(
                  color: Color.fromARGB(255, 0, 225, 255),
                  backgroundColor: Color.fromARGB(255, 247, 242, 242),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: appBar,
            body: SizedBox(
              width: wdth,
              height: hght,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('coins')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState != ConnectionState.active) {
                    _isLoading = true;
                    return Container();
                  } else if (snapshot.connectionState ==
                          ConnectionState.active &&
                      snapshot.hasError) {
                    _isLoading = false;

                    return RefreshIndicator.adaptive(
                      onRefresh: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('coins')
                            .snapshots();

                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: ListView(
                        padding: EdgeInsets.only(
                          left: wdth * 0.1,
                          right: wdth * 0.1,
                          top: hght * 0.4,
                        ),
                        children: [
                          Center(
                            child: Text(
                              "There was an Error while Loading data...",
                              textScaleFactor:
                                  hght > wdth ? hght * 0.0015 : wdth * 0.002,
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    _isLoading = false;
                    return LiquidPullToRefresh(
                      color: Colors.cyan,
                      backgroundColor: Colors.white,
                      height: 200,
                      onRefresh: () async {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('coins')
                            .snapshots();
                        return Future.delayed(const Duration(seconds: 2));
                      },
                      child: ListView(
                        children: snapshot.data!.docs.map((document) {
                          return Padding(
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 45),
                              width: wdth,
                              height: kIsWeb
                                  ? hght > wdth
                                      ? wdth * 0.085
                                      : hght * 0.08
                                  : hght > wdth
                                      ? wdth * 0.13
                                      : hght * 0.13,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.horizontal(),
                                color: Color.fromARGB(179, 230, 230, 230),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        document.id,
                                        style: TextStyle(
                                          fontSize: hght > wdth
                                              ? hght * 0.025
                                              : hght * 0.035,
                                          color: const Color.fromARGB(
                                              255, 4, 29, 250),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "₹",
                                            style: TextStyle(
                                              fontSize: hght > wdth
                                                  ? hght * 0.025
                                                  : hght * 0.05,
                                              color: const Color.fromARGB(
                                                  255, 5, 202, 5),
                                            ),
                                          ),
                                          Text(
                                            " ${getValues(document.id, document.get('amount').toDouble()).toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontSize: hght > wdth
                                                  ? hght * 0.015
                                                  : hght * 0.03,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      _delete
                                          ? Row(
                                              children: [
                                                IconButton(
                                                  iconSize: wdth > 600
                                                      ? hght * 0.04
                                                      : wdth * 0.05,
                                                  icon: Icon(
                                                    Icons.check,
                                                    color: const Color.fromARGB(
                                                        255, 4, 248, 12),
                                                    size: wdth > 600
                                                        ? hght * 0.04
                                                        : wdth * 0.05,
                                                  ),
                                                  onPressed: () async {
                                                    String delete = "unknown";

                                                    kIsWeb
                                                        ? showCupertinoDialog(
                                                            useRootNavigator:
                                                                true,
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder: (context) {
                                                              return Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: appBar
                                                                          .preferredSize
                                                                          .height *
                                                                      1.1,
                                                                  bottom: hght -
                                                                      appBar.preferredSize
                                                                              .height *
                                                                          1.2,
                                                                ),
                                                                child:
                                                                    const LinearProgressIndicator(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          225,
                                                                          255),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey,
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : showCupertinoDialog(
                                                            useRootNavigator:
                                                                true,
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder: (context) {
                                                              return Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: appBar
                                                                          .preferredSize
                                                                          .height *
                                                                      1.7,
                                                                  bottom: hght -
                                                                      appBar.preferredSize
                                                                              .height *
                                                                          1.8,
                                                                ),
                                                                child:
                                                                    const LinearProgressIndicator(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          225,
                                                                          255),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey,
                                                                ),
                                                              );
                                                            },
                                                          );

                                                    delete = await removeCoin(
                                                        document.id);

                                                    if (delete == "true") {
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        _delete = false;
                                                      });
                                                      // ignore: use_build_context_synchronously
                                                      showSnackBar(
                                                          context, "deleted");
                                                    } else if (delete !=
                                                        "unknown") {
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.pop(context);
                                                      // ignore: use_build_context_synchronously
                                                      showSnackBar(
                                                          context, delete);
                                                    }
                                                  },
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: wdth * 0.015,
                                                  ),
                                                  child: IconButton(
                                                    iconSize: wdth > 600
                                                        ? hght * 0.04
                                                        : wdth * 0.05,
                                                    icon: Icon(
                                                      Icons.close_rounded,
                                                      color: Colors.red,
                                                      size: wdth > 600
                                                          ? hght * 0.04
                                                          : wdth * 0.05,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _delete = false;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          : IconButton(
                                              alignment: Alignment.center,
                                              iconSize: wdth > 600
                                                  ? hght * 0.04
                                                  : wdth * 0.05,
                                              icon: Icon(
                                                Icons.delete_rounded,
                                                color: const Color.fromARGB(
                                                  255,
                                                  238,
                                                  108,
                                                  99,
                                                ),
                                                size: wdth > 600
                                                    ? hght * 0.04
                                                    : wdth * 0.05,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _delete = true;
                                                });
                                              },
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              isExtended: true,
              backgroundColor: Colors.cyan,
              hoverColor: const Color.fromARGB(255, 7, 207, 34),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddView()));
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          );
  }
}
