import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

class homeweeb extends StatefulWidget {
  @override
  _homeweebState createState() => _homeweebState();
}

class _homeweebState extends State<homeweeb> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 80, child: SearchBar(onSearch: null, onItemFound: null,
            textStyle: TextStyle(color:Colors.white),
            hintText: 'Search for an Anime...',),),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                margin: EdgeInsets.only(left: 5, top: 7),
                child: Text(
                  'Top Animes', style: TextStyle(
                  fontSize: 20,
                ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 7),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text('View More',style: TextStyle(
                        fontSize: 20,
                      ),),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              )
            ]), //Top Animes
            Container(
              height: 210,
              margin: EdgeInsets.only(top: 5),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/1223/96541.jpg?s=faffcb677a5eacd17bf761edd78bfb3f',
                      'FMA'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/11/33657.jpg?s=5724d8c22ae7a1dad72d8f4229ef803f',
                      'HxH'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/3/72078.jpg?s=e9537ac90c08758594c787ede117f209',
                      'Gintama'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/1517/100633.jpg?s=4540a01b5883647ade494cd28392f100',
                      'AOT'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/4/9391.jpg?s=be052972605dd5422ef2df117766cff0',
                      'Code Gege'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/1918/96303.jpg?s=b5b51cff7ba201e4f1acf37f4f44e224',
                      'culturedstuff'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/4/19644.jpg?s=bb1e96eb0a0224a57aa45443eab92575',
                      'CBB'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/12/76049.jpg?s=40b6c7dbbbb94c44675116d301150078',
                      'One Punch Man'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/11/39717.jpg?s=5908e8051487fb8468d5fca779f8f00d',
                      'Sword Art Online'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/5/64449.jpg?s=f1af76501ac3d4238170191d5e0679f2',
                      'Tokyo Ghoul'),
                ],
              ),
            ),
            Container(
              height: 75,
              color: Colors.black54,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GenreCapsules('Action', Colors.red),
                  GenreCapsules('Adventure', Colors.blue),
                  GenreCapsules('Comedy', Colors.green),
                  GenreCapsules('Romance', Colors.pink),
                  GenreCapsules('Slice of Life', Colors.deepOrange),
                  GenreCapsules('Sports', Colors.deepPurple),
                  GenreCapsules('', Colors.white, icon: Icons.search)
                ],
              ),
            ), //genres
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                margin: EdgeInsets.only(left: 5, top: 7),
                child: Text(
                  'Top Airing',style: TextStyle(
                  fontSize: 20,
                ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 7),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text('View More',style: TextStyle(
                        fontSize: 20,
                      ),),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              )
            ]), //topairing
            Container(
              height: 210,
              margin: EdgeInsets.only(top: 5),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/1223/96541.jpg?s=faffcb677a5eacd17bf761edd78bfb3f',
                      'FMA'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/11/33657.jpg?s=5724d8c22ae7a1dad72d8f4229ef803f',
                      'HxH'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/3/72078.jpg?s=e9537ac90c08758594c787ede117f209',
                      'Gintama'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/1517/100633.jpg?s=4540a01b5883647ade494cd28392f100',
                      'AOT'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/4/9391.jpg?s=be052972605dd5422ef2df117766cff0',
                      'Code Gege'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/1918/96303.jpg?s=b5b51cff7ba201e4f1acf37f4f44e224',
                      'culturedstuff'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/4/19644.jpg?s=bb1e96eb0a0224a57aa45443eab92575',
                      'CBB'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/12/76049.jpg?s=40b6c7dbbbb94c44675116d301150078',
                      'One Punch Man'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/11/39717.jpg?s=5908e8051487fb8468d5fca779f8f00d',
                      'Sword Art Online'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/5/64449.jpg?s=f1af76501ac3d4238170191d5e0679f2',
                      'Tokyo Ghoul'),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                margin: EdgeInsets.only(left: 5, top: 7),
                child: Text(
                  'Top TV',style: TextStyle(
                  fontSize: 20,
                ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 7),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text('View More',style: TextStyle(
                        fontSize: 20,
                      ),),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              )
            ]),//Top Tv
            Container(
              height: 210,
              margin: EdgeInsets.only(top: 5),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/1223/96541.jpg?s=faffcb677a5eacd17bf761edd78bfb3f',
                      'FMA'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/11/33657.jpg?s=5724d8c22ae7a1dad72d8f4229ef803f',
                      'HxH'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/3/72078.jpg?s=e9537ac90c08758594c787ede117f209',
                      'Gintama'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/1517/100633.jpg?s=4540a01b5883647ade494cd28392f100',
                      'AOT'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/4/9391.jpg?s=be052972605dd5422ef2df117766cff0',
                      'Code Gege'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/1918/96303.jpg?s=b5b51cff7ba201e4f1acf37f4f44e224',
                      'culturedstuff'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/4/19644.jpg?s=bb1e96eb0a0224a57aa45443eab92575',
                      'CBB'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/12/76049.jpg?s=40b6c7dbbbb94c44675116d301150078',
                      'One Punch Man'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/11/39717.jpg?s=5908e8051487fb8468d5fca779f8f00d',
                      'Sword Art Online'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/5/64449.jpg?s=f1af76501ac3d4238170191d5e0679f2',
                      'Tokyo Ghoul'),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                margin: EdgeInsets.only(left: 5, top: 7),
                child: Text(
                  'Top Movies',style: TextStyle(
                  fontSize: 20,
                ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 7),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text('View More',style: TextStyle(
                        fontSize: 20,
                      ),),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              )
            ]),//Top Movies
            Container(
              height: 210,
              margin: EdgeInsets.only(top: 5),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/1223/96541.jpg?s=faffcb677a5eacd17bf761edd78bfb3f',
                      'FMA'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/11/33657.jpg?s=5724d8c22ae7a1dad72d8f4229ef803f',
                      'HxH'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/3/72078.jpg?s=e9537ac90c08758594c787ede117f209',
                      'Gintama'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/1517/100633.jpg?s=4540a01b5883647ade494cd28392f100',
                      'AOT'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/4/9391.jpg?s=be052972605dd5422ef2df117766cff0',
                      'Code Gege'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/1918/96303.jpg?s=b5b51cff7ba201e4f1acf37f4f44e224',
                      'culturedstuff'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/4/19644.jpg?s=bb1e96eb0a0224a57aa45443eab92575',
                      'CBB'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/12/76049.jpg?s=40b6c7dbbbb94c44675116d301150078',
                      'One Punch Man'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/11/39717.jpg?s=5908e8051487fb8468d5fca779f8f00d',
                      'Sword Art Online'),
                  AnimeThumbNails(
                      'https://cdn.myanimelist.net/images/anime/5/64449.jpg?s=f1af76501ac3d4238170191d5e0679f2',
                      'Tokyo Ghoul'),
                ],
              ),
            ),

          ],
        ), //Top Overall
      ],
    );
  }
}
Container AnimeThumbNails(String imgUrl, String animeTitle) {
    return Container(
      margin: EdgeInsets.all(3),
      child: Wrap(
        children: [
          Column(children: [
            InkWell(
              borderRadius: BorderRadius.circular(7),
              onTap: () {
                print('tapped');
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  imgUrl,
                  height: 180,
                  width: (180 * 0.64),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Container(
              width: (180 * 0.64),
              child: Text(
                animeTitle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
        ],
      ),
    );
  }


Container GenreCapsules(String genre, var color, {var icon}) {
  return Container(
    width: 200,
    margin: EdgeInsets.all(5),
    child: Card(
      elevation: 5,
      color: color,
      shadowColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(30),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon == null
                  ? Text(
                      genre,
                      style: TextStyle(fontSize: 25),
                    )
                  : Icon(
                      icon,
                      size: 50,
                      color: Colors.black,
                    ),
            ],
          ),
        ),
      ),
    ),
  );
}
