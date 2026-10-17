import 'package:e_learning/features/videos/data/models/video_item.dart';

abstract class VideosState {}

class VideosInitial extends VideosState {}

class VideosLoading extends VideosState {}

class VideosSuccess extends VideosState {
  VideosSuccess({required this.videos});

  final List<VideoItem> videos;
}

class VideosFailure extends VideosState {
  VideosFailure({required this.errorMessage});

  final String errorMessage;
}

class AddVideoLoading extends VideosState {}

class AddVideoSuccess extends VideosState {
  AddVideoSuccess({required this.message});

  final String message;
}

class AddVideoFailure extends VideosState {
  AddVideoFailure({required this.errorMessage});

  final String errorMessage;
}

class DeleteVideoLoading extends VideosSuccess {
  DeleteVideoLoading({required super.videos, required this.videoId});

  final String videoId;
}

class DeleteVideoSuccess extends VideosSuccess {
  DeleteVideoSuccess({required super.videos, required this.message});

  final String message;
}

class DeleteVideoFailure extends VideosSuccess {
  DeleteVideoFailure({required super.videos, required this.errorMessage});

  final String errorMessage;
}
