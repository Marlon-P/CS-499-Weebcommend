
import 'animes.dart';
import 'dart:convert';
import 'package:http/http.dart';
import  'dart:async';

enum Genres {
  genre,
 action,
 adventure,
 cars,
 comedy,
 dementia,
 demons,
 mystery,
 drama,
 ecchi,
 fantasy,
 game,
 hentai,
 historical,
 horror,
 kids,
 magic,
 martialArts,
 mecha,
 music,
 parody,
 samurai,
 romance,
 school,
 sciFi,
 shoujo,
 shoujoAi,
 shounen,
 ShounenAi,
 space,
 sports,
 superPower,
 vampire,
 yaoi,
 yuri,
 harem,
 sliceOfLife,
 supernatural,
 psychological,
 thriller,
 seinen,
 josei
}
Future<List<Anime>> advanceSearch(List<Anime> animeList, {String query, int page, String status, String rated, List<Genres> genres, int score, String order_by})async {
 var url = 'https://api.jikan.moe/v3/search/anime?';
 if (query != null) {
  query.replaceAll(' ', '%20');
  url += 'q=$query&';
 } else if (page != null) {
  url += 'page=$page&';
 } else if (status != null) {
  url += 'status=$status&';
 } else if (rated != null) {
  url += 'rated=$rated&';
 } else if (genres != null) {
  url += 'genre=';
  for (var eachGenres in genres) {
   url += eachGenres.index.toString() + ',';
  }
  url += '&';
 } else if (score != null) {
  url += 'score=$score&';
 } else if (order_by != null) {
  url += 'order_by=$order_by&';
 } else {
  print('insufficient parameters');
 }
 Response response = await get(url);
 Map data = jsonDecode(response.body);
 List animes = data['results'];
 print(animeList.length);
 for (var eachAnime in animes){
  animeList.add(Anime(title:eachAnime['title'],rated: eachAnime['rated'],type: eachAnime['type'],episodes: eachAnime['episodes'],members: eachAnime['members'],airing: eachAnime['airing'],mal_id: eachAnime['mal_id'],score: eachAnime['score'],synopsis: eachAnime['synopsis']));
 }
 // print(animeList);
 return animes;
}

//https://api.jikan.moe/v3/search/anime?genre=12&order_by=score