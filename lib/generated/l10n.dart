// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `The end`
  String get finalPage_endText {
    return Intl.message(
      'The end',
      name: 'finalPage_endText',
      desc: '',
      args: [],
    );
  }

  /// `Authors:`
  String get finalPage_authors {
    return Intl.message(
      'Authors:',
      name: 'finalPage_authors',
      desc: '',
      args: [],
    );
  }

  /// `Play`
  String get menuPage_play {
    return Intl.message(
      'Play',
      name: 'menuPage_play',
      desc: '',
      args: [],
    );
  }

  /// `Skills`
  String get menuPage_skills {
    return Intl.message(
      'Skills',
      name: 'menuPage_skills',
      desc: '',
      args: [],
    );
  }

  /// `Shop`
  String get menuPage_shop {
    return Intl.message(
      'Shop',
      name: 'menuPage_shop',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get menuPage_online {
    return Intl.message(
      'Online',
      name: 'menuPage_online',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get menuPage_sign {
    return Intl.message(
      'Sign in with Google',
      name: 'menuPage_sign',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get menuPage_logout {
    return Intl.message(
      'Logout',
      name: 'menuPage_logout',
      desc: '',
      args: [],
    );
  }

  /// `Inventory`
  String get menuPage_items {
    return Intl.message(
      'Inventory',
      name: 'menuPage_items',
      desc: '',
      args: [],
    );
  }

  /// `Account Management`
  String get menuPage_acc_m {
    return Intl.message(
      'Account Management',
      name: 'menuPage_acc_m',
      desc: '',
      args: [],
    );
  }

  /// `Training`
  String get menuPage_training {
    return Intl.message(
      'Training',
      name: 'menuPage_training',
      desc: '',
      args: [],
    );
  }

  /// `Tip: tap to win`
  String get menuPage_tip {
    return Intl.message(
      'Tip: tap to win',
      name: 'menuPage_tip',
      desc: '',
      args: [],
    );
  }

  /// `Skip if you know how to play`
  String get menuPage_skip {
    return Intl.message(
      'Skip if you know how to play',
      name: 'menuPage_skip',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get onlinePage_title {
    return Intl.message(
      'Online',
      name: 'onlinePage_title',
      desc: '',
      args: [],
    );
  }

  /// `Rank:`
  String get onlinePage_rank {
    return Intl.message(
      'Rank:',
      name: 'onlinePage_rank',
      desc: '',
      args: [],
    );
  }

  /// `Won`
  String get onlinePage_won {
    return Intl.message(
      'Won',
      name: 'onlinePage_won',
      desc: '',
      args: [],
    );
  }

  /// `games`
  String get onlinePage_games {
    return Intl.message(
      'games',
      name: 'onlinePage_games',
      desc: '',
      args: [],
    );
  }

  /// `Find a random game`
  String get onlinePage_find {
    return Intl.message(
      'Find a random game',
      name: 'onlinePage_find',
      desc: '',
      args: [],
    );
  }

  /// `second(s) have passed`
  String get onlinePage_passed {
    return Intl.message(
      'second(s) have passed',
      name: 'onlinePage_passed',
      desc: '',
      args: [],
    );
  }

  /// `Stop the search`
  String get onlinePage_stop {
    return Intl.message(
      'Stop the search',
      name: 'onlinePage_stop',
      desc: '',
      args: [],
    );
  }

  /// `beginner`
  String get onlinePage_beginner {
    return Intl.message(
      'beginner',
      name: 'onlinePage_beginner',
      desc: '',
      args: [],
    );
  }

  /// `soldier`
  String get onlinePage_soldier {
    return Intl.message(
      'soldier',
      name: 'onlinePage_soldier',
      desc: '',
      args: [],
    );
  }

  /// `master`
  String get onlinePage_master {
    return Intl.message(
      'master',
      name: 'onlinePage_master',
      desc: '',
      args: [],
    );
  }

  /// `genius`
  String get onlinePage_genius {
    return Intl.message(
      'genius',
      name: 'onlinePage_genius',
      desc: '',
      args: [],
    );
  }

  /// `global elite`
  String get onlinePage_global_elite {
    return Intl.message(
      'global elite',
      name: 'onlinePage_global_elite',
      desc: '',
      args: [],
    );
  }

  /// `Back to the game`
  String get onlinePage_back {
    return Intl.message(
      'Back to the game',
      name: 'onlinePage_back',
      desc: '',
      args: [],
    );
  }

  /// `Choose level:`
  String get playPage_title {
    return Intl.message(
      'Choose level:',
      name: 'playPage_title',
      desc: '',
      args: [],
    );
  }

  /// `Noob`
  String get playPage_noob {
    return Intl.message(
      'Noob',
      name: 'playPage_noob',
      desc: '',
      args: [],
    );
  }

  /// `Try to choose a different level`
  String get playPage_try {
    return Intl.message(
      'Try to choose a different level',
      name: 'playPage_try',
      desc: '',
      args: [],
    );
  }

  /// `Soldier`
  String get playPage_soldier {
    return Intl.message(
      'Soldier',
      name: 'playPage_soldier',
      desc: '',
      args: [],
    );
  }

  /// `Candidate`
  String get playPage_candidate {
    return Intl.message(
      'Candidate',
      name: 'playPage_candidate',
      desc: '',
      args: [],
    );
  }

  /// `Expert`
  String get playPage_expert {
    return Intl.message(
      'Expert',
      name: 'playPage_expert',
      desc: '',
      args: [],
    );
  }

  /// `Boss`
  String get playPage_boss {
    return Intl.message(
      'Boss',
      name: 'playPage_boss',
      desc: '',
      args: [],
    );
  }

  /// `Buy items`
  String get shopPage_title {
    return Intl.message(
      'Buy items',
      name: 'shopPage_title',
      desc: '',
      args: [],
    );
  }

  /// `Coins`
  String get shopPage_coins {
    return Intl.message(
      'Coins',
      name: 'shopPage_coins',
      desc: '',
      args: [],
    );
  }

  /// `You have:`
  String get shopPage_youHave {
    return Intl.message(
      'You have:',
      name: 'shopPage_youHave',
      desc: '',
      args: [],
    );
  }

  /// `Elixir`
  String get shopPage_elixir {
    return Intl.message(
      'Elixir',
      name: 'shopPage_elixir',
      desc: '',
      args: [],
    );
  }

  /// `Keys`
  String get shopPage_keys {
    return Intl.message(
      'Keys',
      name: 'shopPage_keys',
      desc: '',
      args: [],
    );
  }

  /// `Super click`
  String get shopPage_stopTimer {
    return Intl.message(
      'Super click',
      name: 'shopPage_stopTimer',
      desc: '',
      args: [],
    );
  }

  /// `No ads`
  String get shopPage_noAds {
    return Intl.message(
      'No ads',
      name: 'shopPage_noAds',
      desc: '',
      args: [],
    );
  }

  /// `Improve your skills`
  String get skillsPage_title {
    return Intl.message(
      'Improve your skills',
      name: 'skillsPage_title',
      desc: '',
      args: [],
    );
  }

  /// `Need coins? Click here`
  String get skillsPage_need {
    return Intl.message(
      'Need coins? Click here',
      name: 'skillsPage_need',
      desc: '',
      args: [],
    );
  }

  /// `Invisibility:`
  String get skillsPage_visibility {
    return Intl.message(
      'Invisibility:',
      name: 'skillsPage_visibility',
      desc: '',
      args: [],
    );
  }

  /// `Speed:`
  String get skillsPage_speed {
    return Intl.message(
      'Speed:',
      name: 'skillsPage_speed',
      desc: '',
      args: [],
    );
  }

  /// `Power:`
  String get skillsPage_power {
    return Intl.message(
      'Power:',
      name: 'skillsPage_power',
      desc: '',
      args: [],
    );
  }

  /// `Invisibility will help you earn more coins`
  String get skillsPage_vDescription {
    return Intl.message(
      'Invisibility will help you earn more coins',
      name: 'skillsPage_vDescription',
      desc: '',
      args: [],
    );
  }

  /// `Speed will add extra more time`
  String get skillsPage_sDescription {
    return Intl.message(
      'Speed will add extra more time',
      name: 'skillsPage_sDescription',
      desc: '',
      args: [],
    );
  }

  /// `Power will restore energy faster`
  String get skillsPage_pDescription {
    return Intl.message(
      'Power will restore energy faster',
      name: 'skillsPage_pDescription',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations you have passed the game`
  String get playGroundPage_final {
    return Intl.message(
      'Congratulations you have passed the game',
      name: 'playGroundPage_final',
      desc: '',
      args: [],
    );
  }

  /// `You have won`
  String get playGroundPage_haveWon {
    return Intl.message(
      'You have won',
      name: 'playGroundPage_haveWon',
      desc: '',
      args: [],
    );
  }

  /// `coins`
  String get playGroundPage_coins {
    return Intl.message(
      'coins',
      name: 'playGroundPage_coins',
      desc: '',
      args: [],
    );
  }

  /// `Tap! Tap! Tap!`
  String get onlinePlayGroundPage_motivation1 {
    return Intl.message(
      'Tap! Tap! Tap!',
      name: 'onlinePlayGroundPage_motivation1',
      desc: '',
      args: [],
    );
  }

  /// `Faster!`
  String get onlinePlayGroundPage_motivation2 {
    return Intl.message(
      'Faster!',
      name: 'onlinePlayGroundPage_motivation2',
      desc: '',
      args: [],
    );
  }

  /// `You can win!`
  String get onlinePlayGroundPage_motivation3 {
    return Intl.message(
      'You can win!',
      name: 'onlinePlayGroundPage_motivation3',
      desc: '',
      args: [],
    );
  }

  /// `Easy peasy lemon squeezy!`
  String get onlinePlayGroundPage_motivation4 {
    return Intl.message(
      'Easy peasy lemon squeezy!',
      name: 'onlinePlayGroundPage_motivation4',
      desc: '',
      args: [],
    );
  }

  /// `Almost a victory!`
  String get onlinePlayGroundPage_motivation5 {
    return Intl.message(
      'Almost a victory!',
      name: 'onlinePlayGroundPage_motivation5',
      desc: '',
      args: [],
    );
  }

  /// `This is your game!`
  String get onlinePlayGroundPage_motivation6 {
    return Intl.message(
      'This is your game!',
      name: 'onlinePlayGroundPage_motivation6',
      desc: '',
      args: [],
    );
  }

  /// `The game is over or not found`
  String get onlinePlayGroundPage_notFound {
    return Intl.message(
      'The game is over or not found',
      name: 'onlinePlayGroundPage_notFound',
      desc: '',
      args: [],
    );
  }

  /// `You have lost`
  String get main_loss {
    return Intl.message(
      'You have lost',
      name: 'main_loss',
      desc: '',
      args: [],
    );
  }

  /// `Draw`
  String get main_draw {
    return Intl.message(
      'Draw',
      name: 'main_draw',
      desc: '',
      args: [],
    );
  }

  /// `You win`
  String get main_win {
    return Intl.message(
      'You win',
      name: 'main_win',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get main_loading {
    return Intl.message(
      'Loading',
      name: 'main_loading',
      desc: '',
      args: [],
    );
  }

  /// `Check your connection`
  String get main_check {
    return Intl.message(
      'Check your connection',
      name: 'main_check',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to leave the game?`
  String get main_exit {
    return Intl.message(
      'Do you want to leave the game?',
      name: 'main_exit',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get main_yes {
    return Intl.message(
      'Yes',
      name: 'main_yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get main_no {
    return Intl.message(
      'No',
      name: 'main_no',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get main_error {
    return Intl.message(
      'Error',
      name: 'main_error',
      desc: '',
      args: [],
    );
  }

  /// `Successfully`
  String get main_succes {
    return Intl.message(
      'Successfully',
      name: 'main_succes',
      desc: '',
      args: [],
    );
  }

  /// `You have already bought`
  String get main_already {
    return Intl.message(
      'You have already bought',
      name: 'main_already',
      desc: '',
      args: [],
    );
  }

  /// `The game is over`
  String get main_surrTrue {
    return Intl.message(
      'The game is over',
      name: 'main_surrTrue',
      desc: '',
      args: [],
    );
  }

  /// `Open the case`
  String get itemsPage_open {
    return Intl.message(
      'Open the case',
      name: 'itemsPage_open',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
