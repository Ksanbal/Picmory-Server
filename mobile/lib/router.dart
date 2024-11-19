import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/viewmodels/auth/signin/signin_viewmodel.dart';
import 'package:picmory/viewmodels/index/for_you/albums/albums_viewmodel.dart';
import 'package:picmory/viewmodels/index/for_you/for_you_viewmodel.dart';
import 'package:picmory/viewmodels/index/for_you/like_memories/like_memories_viewmodel.dart';
import 'package:picmory/viewmodels/index/home/home_viewmodel.dart';
import 'package:picmory/viewmodels/index/index_viewmodel.dart';
import 'package:picmory/viewmodels/memory/create/memory_create_viewmodel.dart';
import 'package:picmory/viewmodels/memory/memory_get_source_viewmodel/memory_get_source_viewmodel.dart';
import 'package:picmory/viewmodels/memory/retrieve/memory_retrieve_viewmodel.dart';
import 'package:picmory/viewmodels/menu/menu_viewmodel.dart';
import 'package:picmory/viewmodels/splash/splash_viewmodel.dart';
import 'package:picmory/views/auth/signin_view.dart';
import 'package:picmory/views/components_view.dart';
import 'package:picmory/views/index/for_you/albums/albums_view.dart';
import 'package:picmory/views/index/for_you/like_memories/like_memories_view.dart';
import 'package:picmory/views/index/index_view.dart';
import 'package:picmory/views/memory/create/memory_create_view.dart';
import 'package:picmory/views/memory/get_source/memory_get_source_view.dart';
import 'package:picmory/views/memory/retrieve/memory_retrieve_view.dart';
import 'package:picmory/views/menu/license/license_view.dart';
import 'package:picmory/views/menu/menu_view.dart';
import 'package:picmory/views/menu/user/user_view.dart';
import 'package:picmory/views/splash/splash_view.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    /**
     * 스플래시 스크린
     */
    GoRoute(
      path: '/components',
      builder: (_, state) => ComponentsView(),
    ),
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
            create: (_) => HomeViewmodel(),
          ),
          ChangeNotifierProvider(
            create: (_) => ForYouViewmodel(),
          ),
        ],
        child: IndexView(),
      ),
      routes: [
        /**
          * memory
          */
        GoRoute(
          path: 'memory',
          builder: (_, state) => Container(),
          routes: [
            GoRoute(
              path: 'get-source',
              builder: (_, state) => ChangeNotifierProvider.value(
                value: MemoryGetSourceViewmodel(),
                child: const MemoryGetSourceView(),
              ),
            ),
            GoRoute(
              path: 'create',
              builder: (_, state) => ChangeNotifierProvider.value(
                value: MemoryCreateViewmodel(),
                child: const MemoryCreateView(),
              ),
            ),
            GoRoute(
              path: ':memoryId',
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
           * for you
           */
        GoRoute(
          path: 'for-you',
          builder: (_, state) => Container(),
          routes: [
            GoRoute(
              path: 'like-memories',
              builder: (_, state) => ChangeNotifierProvider.value(
                value: LikeMemoriesViewmodel(),
                child: const LikeMemoriesView(),
              ),
            ),
            GoRoute(
              path: 'albums/:id',
              builder: (_, state) => ChangeNotifierProvider.value(
                value: AlbumsViewmodel(
                  int.parse(state.pathParameters['id']!),
                ),
                child: const AlbumsView(),
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
          routes: [
            GoRoute(
              path: 'user',
              builder: (_, state) => ChangeNotifierProvider.value(
                value: MenuViewmodel(),
                child: const UserView(),
              ),
            ),
            GoRoute(
              path: 'license',
              builder: (_, state) => const LicenseView(),
            ),
          ],
        ),
      ],
    ),
  ],
);
