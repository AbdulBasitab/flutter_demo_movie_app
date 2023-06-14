import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/constants/data_constants.dart';
import '../../models/movie/movie.dart';
import '../../models/movie_detail/movie_detail.dart';
import '../../models/tv_detail/tv_detail.dart';
import '../../models/tv_show/tv_show.dart';
import 'api_service_cubit_state.dart';

class MoviesCubit extends Cubit<ApiServiceCubit> with ApiServiceConstants {
  MoviesCubit() : super(InitCubit());

  Future<void> fetchTrendingMovies() async {
    emit(LoadingMovieState());
    final response = await http
        .get(Uri.parse('$baseUrl/trending/movie/week?api_key=$apiKey'));
    // print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      var trendMovies = <Movie>[];
      trendMovies = <Movie>[
        ...data['results']
            .map((trendmovie) => Movie.fromJson(trendmovie))
            .toList()
      ];

      emit(TrendingMovieState(trendingMovies: trendMovies));
      //return trendMovies;
    } else {
      // If the response was umexpected, throw an error.
      emit(ErrorMovieState("Failed to load movies"));
      throw Exception('Failed to load movies');
    }
  }
}

class MovieDetailCubit extends Cubit<ApiServiceCubit> with ApiServiceConstants {
  MovieDetailCubit() : super(InitCubit());

  Future<void> fetchTrendingMovieDetail(double moviekey) async {
    emit(LoadingMovieState());
    final response =
        await http.get(Uri.parse('$baseUrl/movie/$moviekey?api_key=$apiKey'));
    print(response);
    if (response.statusCode == 200) {
      var movieDetails = json.decode(response.body);
      var movieDetail = MovieDetail.fromJson(movieDetails);
      // print(movieDetail);
      emit(TrendingMovieDetailState(movieDetail: movieDetail));
    } else {
      emit(ErrorMovieState("Error 404"));
      throw Exception('Failed to load details');
    }
  }
}

class TvShowsCubit extends Cubit<ApiServiceCubit> with ApiServiceConstants {
  TvShowsCubit() : super(InitCubit());

  Future<void> fetchPopularTv() async {
    emit(LoadingMovieState());
    final response = await http.get(Uri.parse(
        '$baseUrl/tv/top_rated?api_key=$apiKey&language=en-US&page=1'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      var popularTvShows = <TvShow>[];
      popularTvShows = <TvShow>[
        ...data['results'].map((trendtv) => TvShow.fromJson(trendtv)).toList()
      ];
      emit(PopularMoviesState(popularTvList: popularTvShows));
    } else {
      // If the response was umexpected, throw an error.
      emit(ErrorMovieState("Error 404"));
      throw Exception('Failed to load movies');
    }
  }
}

class PopularTvDetailCubit extends Cubit<ApiServiceCubit>
    with ApiServiceConstants {
  PopularTvDetailCubit() : super(InitCubit());

  Future<void> fetchPopularTvDetail(double tvKey) async {
    emit(LoadingMovieState());
    final response = await http
        .get(Uri.parse('$baseUrl/tv/$tvKey?api_key=$apiKey&language=en-US'));
    // print(response.body);
    if (response.statusCode == 200) {
      var poptvDetails = json.decode(response.body);
      var poptvDetail = TvDetail.fromJson(poptvDetails);

      emit(PopularMovieDetailState(popularTvDetail: poptvDetail));
    } else {
      emit(ErrorMovieState("Error 404"));
      throw Exception('Failed to load details');
    }
  }
}

class SearchMoviesShowCubit extends Cubit<ApiServiceCubit>
    with ApiServiceConstants {
  SearchMoviesShowCubit() : super(InitCubit());

  Future<List<Movie>> searchMovies(String query) async {
    emit(LoadingMovieState());
    var response = await http.get(Uri.parse(
        "$baseUrl/search/movie?query=$query&include_adult=false&language=en-US&page=1&api_key=$apiKey"));
    print(response.body);
    final data = json.decode(response.body) as Map<String, dynamic>;
    var searchedMovies = <Movie>[];
    searchedMovies = [
      ...data['results'].map((movie) => Movie.fromJson(movie)).toList()
    ];
    if (searchedMovies.isNotEmpty) {
      searchedMovies.sort((a, b) => b.rating!.compareTo(a.rating!));
      emit(SearchMoviesState(searchedMovies));
    } else {
      emit(ErrorMovieState("No Movies found"));
    }
    return searchedMovies;
  }
}

class SimilarMoviesCubit extends Cubit<ApiServiceCubit>
    with ApiServiceConstants {
  SimilarMoviesCubit() : super(InitCubit());

  Future<List<Movie>> fetchSimilarMovies(int movieId) async {
    emit(LoadingMovieState());
    var response = await http.get(Uri.parse(
        "$baseUrl/movie/$movieId/similar?language=en-US&page=1&api_key=$apiKey"));
    print(response.body);
    final data = json.decode(response.body) as Map<String, dynamic>;
    var similarMovies = <Movie>[];
    similarMovies = [
      ...data['results'].map((movie) => Movie.fromJson(movie)).toList()
    ];
    if (similarMovies.isNotEmpty) {
      emit(SimilarMoviesState(similarMovies));
    } else {
      emit(ErrorMovieState("No Movies found"));
    }
    return similarMovies;
  }
}

class ApiServiceConstants {
  final baseUrl = DataConstants.baseUrl;
  final apiKey = DataConstants.apiKey;
}
