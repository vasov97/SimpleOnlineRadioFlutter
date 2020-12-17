import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:ai_radio/constants.dart';
import 'package:ai_radio/models/radio.dart';
import 'package:ai_radio/models/radio_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<MyRadio> radios;
  MyRadio _selectedRadio;
  Color _selectedColor;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    fetchRadios();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == AudioPlayerState.PLAYING) _isPlaying = true;
    });
    setState(() {});
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).myRadioList;
    _selectedRadio = radios[0];
    _selectedColor = Color(int.tryParse(_selectedRadio.color));
    setState(() {});
  }

  _playMusic(String url) {
    _audioPlayer.play(url);
    _selectedRadio = radios.firstWhere((element) => element.url == url);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: _selectedColor ?? primaryColorBlue,
          child: radios != null
              ? [
                  100.heightBox,
                  "All channels".text.xl.white.semiBold.make().p16(),
                  20.heightBox,
                  ListView(
                          padding: Vx.m0,
                          shrinkWrap: true,
                          children: radios
                              .map((e) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(e.icon),
                                  ),
                                  title: "${e.name} FM.".text.white.make(),
                                  subtitle: e.tagline.text.white.make()))
                              .toList())
                      .expand(),
                ].vStack(crossAlignment: CrossAxisAlignment.start)
              : const Offstage(),
        ),
      ),
      body: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(
                (LinearGradient(
                  colors: [
                    primaryColorGreen,
                    _selectedColor ?? primaryColorBlue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )),
              )
              .make(),
          [
            AppBar(
              title: "RadioApp".text.xl4.bold.white.make().shimmer(
                  primaryColor: primaryColorBlue, secondaryColor: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              centerTitle: true,
            ).h(100).p16(),
            20.heightBox,
          ].vStack(alignment: MainAxisAlignment.start),
          30.heightBox,
          radios != null
              ? VxSwiper.builder(
                  itemCount: radios.length,
                  aspectRatio: context.mdWindowSize == MobileWindowSize.xsmall
                      ? 1.0
                      : context.mdWindowSize == MobileWindowSize.medium
                          ? 2.0
                          : 3.0,
                  enlargeCenterPage: true,
                  onPageChanged: (index) {
                    _selectedRadio = radios[index];
                    final color = radios[index].color;
                    _selectedColor = Color(int.tryParse(color));
                    setState(() {});
                  },
                  itemBuilder: (context, index) {
                    final radioToDisplay = radios[index];
                    return VxBox(
                            child: ZStack(
                      [
                        Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: VxBox(
                              child: radioToDisplay
                                  .category.text.uppercase.white
                                  .make()
                                  .px16(),
                            )
                                .height(40)
                                .black
                                .alignCenter
                                .withRounded(value: 10.0)
                                .make()),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: VStack(
                              [
                                radioToDisplay.name.text.xl3.white.bold.make(),
                                5.heightBox,
                                radioToDisplay.tagline.text.sm.white.semiBold
                                    .make(),
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                            )),
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                            CupertinoIcons.play_circle,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ))
                        .clip(Clip.antiAlias)
                        .bgImage(DecorationImage(
                            image: NetworkImage(radioToDisplay.image),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken)))
                        .border(color: Colors.white, width: 3.0)
                        .withRounded(value: 42.0)
                        .make()
                        .onInkDoubleTap(() {
                      _playMusic(radioToDisplay.url);
                    }).p16();
                  },
                ).centered()
              : Center(
                  child: CircularProgressIndicator(
                    backgroundColor: whiteColor,
                  ),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: [
              if (_isPlaying)
                "Playing Now - ${_selectedRadio.name} FM"
                    .text
                    .white
                    .makeCentered(),
              Icon(
                      _isPlaying
                          ? CupertinoIcons.stop_circle
                          : CupertinoIcons.play_circle,
                      color: Colors.white,
                      size: 50.0)
                  .onInkTap(() {
                if (_isPlaying)
                  _audioPlayer.stop();
                else
                  _playMusic(_selectedRadio.url);
              })
            ].vStack(),
          ).pOnly(bottom: context.percentHeight * 12),
        ],
        fit: StackFit.expand,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
