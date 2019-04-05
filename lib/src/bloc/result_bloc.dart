import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:medid/src/models/match_result.dart';
import 'package:medid/src/models/pill_extended.dart';
import 'package:medid/src/repositories/pill_repository.dart';
import './bloc.dart';

class ResultBloc extends Bloc<ResultEvent, ResultState> {
  final PillRepository pillRepository;

  ResultBloc({@required this.pillRepository});
  @override
  ResultState get initialState => LoadingMatches();
  @override
  Stream<ResultState> mapEventToState(
    ResultEvent event,
  ) async* {
    if (event is MatchClicked) {
      try {
        final ExtendedPill info =
            await pillRepository.getExtendedPill(event.clickedMr.tradeName);
        yield ShowPillInfo(pillInfo: info);
      } catch (_) {
        yield ShowPillInfoError();
      }
    }
    if (event is ResultPageLoaded) {
      try {
        final List<MatchResult> rs =
            await pillRepository.identifyPill(null);
        yield FoundMatches(results: rs);
      } catch (_) {
        yield MatchingError();
      }
    }
  }
}
