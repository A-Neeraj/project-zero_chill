import 'package:chill/bloc/search/bloc.dart';
import 'package:chill/models/user.dart';
import 'package:chill/repositories/searchRepository.dart';
import 'package:chill/ui/widgets/iconWidget.dart';
import 'package:chill/ui/widgets/profile.dart';
import 'package:chill/ui/widgets/userGender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Search extends StatefulWidget {
  final String userId;

  const Search({this.userId});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SearchRepository _searchRepository = SearchRepository();
  SearchBloc _searchBloc;
  User _user, _currentUser;
  int difference;

  getDifference(GeoPoint userLocation) async {
    Position position = await Geolocator.getCurrentPosition();

    double location = await Geolocator.distanceBetween(userLocation.latitude,
        userLocation.longitude, position.latitude, position.longitude);

    difference = location.toInt();
    print(difference);
  }

  @override
  void initState() {
    _searchBloc = SearchBloc(searchRepository: _searchRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<SearchBloc, SearchState>(
      bloc: _searchBloc,
      builder: (context, state) {
        if (state is InitialSearchState) {
          print('Initial');
          _searchBloc.add(
            LoadUserEvent(userId: widget.userId),
          );
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
            ),
          );
        }
        if (state is LoadingState) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
            ),
          );
        }
        if (state is LoadUserState) {
          _user = state.user;
          _currentUser = state.currentUser;

          getDifference(_user.location);
          if (_user.location == null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        child: Visibility(
                          // visible: _isVisible,
                          child: Container(
                            height: 20,
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Text(
                              "No more people. Waiting!!",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                              // scrollAxis: Axis.horizontal,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              // blankSpace: 20.0,
                              // startPadding: 3,
                              // velocity: 50.0,
                              // pauseAfterRound: Duration(seconds: 1),
                              // showFadingOnlyWhenScrolling: true,
                              // fadingEdgeStartFraction: 0.1,
                              // fadingEdgeEndFraction: 0.1,
                              // numberOfRounds: 100,
                              // accelerationDuration: Duration(seconds: 1),
                              // accelerationCurve: Curves.linear,
                              // decelerationDuration: Duration(milliseconds: 500),
                              // decelerationCurve: Curves.easeOut,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            child: Visibility(
                              // visible: _isVisible,
                              child: Container(
                                height: size.height * 0.2,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: new FlareActor(
                                  "assets/animations/waiting.flr",
                                  alignment: Alignment.center,
                                  fit: BoxFit.fill,
                                  animation: "Blue",
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Visibility(
                              // visible: _isVisible,
                              child: Container(
                                height: size.height * 0.4,
                                width: MediaQuery.of(context).size.width * 0.55,
                                child: new FlareActor(
                                  "assets/animations/construction.flr",
                                  alignment: Alignment.center,
                                  fit: BoxFit.contain,
                                  animation: "EmptyCards",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else
            return profileWidget(
              padding: size.height * 0.035,
              photoHeight: size.height * 0.824,
              photoWidth: size.width * 0.95,
              photo: _user.photo,
              clipRadius: size.height * 0.02,
              containerHeight: size.height * 0.3,
              containerWidth: size.width * 0.9,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.06,
                    ),
                    Row(
                      children: <Widget>[
                        userGender(_user.gender),
                        Expanded(
                          child: Text(
                            " " +
                                _user.name +
                                ", " +
                                (DateTime.now().year - _user.age.toDate().year)
                                    .toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.05),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        Text(
                          difference != null
                              ? (difference / 1000).floor().toString() +
                                  "km away"
                              : "away",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        iconWidget(EvaIcons.flash, () {}, size.height * 0.04,
                            Colors.yellow),
                        iconWidget(Icons.clear, () {
                          _searchBloc
                              .add(PassUserEvent(widget.userId, _user.uid));
                        }, size.height * 0.08, Colors.blue),
                        iconWidget(FontAwesomeIcons.solidHeart, () {
                          _searchBloc.add(
                            SelectUserEvent(
                                name: _currentUser.name,
                                photoUrl: _currentUser.photo,
                                currentUserId: widget.userId,
                                selectedUserId: _user.uid),
                          );
                        }, size.height * 0.06, Colors.red),
                        iconWidget(EvaIcons.options2, () {}, size.height * 0.04,
                            Colors.white)
                      ],
                    )
                  ],
                ),
              ),
            );
        } else
          return Container();
      },
    );
  }
}
