import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/viewmodels/auth/signin/signin_viewmodel.dart';
import 'package:picmory/viewmodels/index/for_you/for_you_viewmodel.dart';
import 'package:picmory/viewmodels/index/home/home_viewmodel.dart';
import 'package:picmory/viewmodels/index/index_viewmodel.dart';
import 'package:picmory/viewmodels/memory/create/memory_create_viewmodel.dart';
import 'package:picmory/viewmodels/memory/retrieve/memory_retrieve_viewmodel.dart';
import 'package:picmory/viewmodels/menu/menu_viewmodel.dart';
import 'package:picmory/viewmodels/splash/splash_viewmodel.dart';
import 'package:picmory/views/auth/signin_view.dart';
import 'package:picmory/views/index/index_view.dart';
import 'package:picmory/views/memory/create/memory_create_view.dart';
import 'package:picmory/views/memory/retrieve/memory_retrieve_view.dart';
import 'package:picmory/views/menu/menu_view.dart';
import 'package:picmory/views/splash/splash_view.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    /**
     * 스플래시 스크린
     */
    GoRoute(
      path: '/splash',
      builder: (_, state) => ChangeNotifierProvider(
        create: (_) => SplashViewmodel(),
        child: const SplashView(),
      ),
    ),
    /**
     * 인증
     */
    GoRoute(
      path: '/auth/signin',
      builder: (_, state) => ChangeNotifierProvider(
        create: (_) => SigninViewmodel(),
        child: const SigninView(),
      ),
    ),
    /**
     * Index
     */
    GoRoute(
        path: '/',
        builder: (_, state) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => IndexViewmodel(),
                ),
                ChangeNotifierProvider(
                  create: (_) => HomeViewmodel(
                    MemoryCreateViewmodel(),
                    MemoryRetrieveViewmodel(),
                  ),
                ),
                ChangeNotifierProvider(
                  create: (_) => ForYouViewmodel(),
                ),
              ],
              child: IndexView(),
            ),
        routes: [
          /**
          * memrory
          */
          GoRoute(
            path: 'memory',
            builder: (_, state) => Container(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (_, state) => ChangeNotifierProvider.value(
                  value: MemoryCreateViewmodel(),
                  child: const MemoryCreateView(),
                ),
              ),
              GoRoute(
                path: ':memoryId',
                // builder: (_, state) => ChangeNotifierProvider.value(
                //   value: MemoryRetrieveViewmodel(),
                //   child: MemoryRetrieveView(
                //     memoryId: state.pathParameters['memoryId']!,
                //   ),
                // ),
                builder: (_, state) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(
                      value: MemoryRetrieveViewmodel(),
                    ),
                    ChangeNotifierProvider(
                      create: (_) => ForYouViewmodel(),
                    ),
                  ],
                  child: MemoryRetrieveView(
                    memoryId: state.pathParameters['memoryId']!,
                  ),
                ),
              ),
            ],
          ),
          /**
          * 메뉴 목록
          */
          GoRoute(
            path: 'menu',
            builder: (_, state) => ChangeNotifierProvider(
              create: (_) => MenuViewmodel(),
              child: const MenuView(),
            ),
          ),
        ]),
  ],
);
