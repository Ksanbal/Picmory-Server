import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:picmory/common/tokens/colors_token.dart';

class IconsToken {
  /// Icon color
  ///
  /// Default value is [ColorsToken.black]
  final Color color;

  /// Icon size
  ///
  /// Default value is [IconTokenSize.medium]
  final IconTokenSize size;

  IconsToken({
    this.color = ColorsToken.black,
    this.size = IconTokenSize.medium,
  });

  final Map<IconTokenSize, double> _sizeMap = {
    IconTokenSize.small: 20.0,
    IconTokenSize.medium: 24.0,
  };

  late final SvgPicture google = SvgPicture.asset(
    'assets/icons/google.svg',
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture apple = SvgPicture.asset(
    'assets/icons/apple.svg',
    colorFilter: ColorFilter.mode(ColorsToken.white, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture addFolderLinear = SvgPicture.asset(
    'assets/icons/add-folder-linear.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture albumBold = SvgPicture.asset(
    'assets/icons/album-bold.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture altArrowLeftLinear = SvgPicture.asset(
    'assets/icons/alt-arrow-left-linear.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture altArrowRightLinear = SvgPicture.asset(
    'assets/icons/alt-arrow-right-linear.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture bookBookmarkMinimalisticLinear = SvgPicture.asset(
    'assets/icons/book-bookmark-minimalistic-linear.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture callChatLinear = SvgPicture.asset(
    'assets/icons/call-chat-linear.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture clipboardTextLinear = SvgPicture.asset(
    'assets/icons/clipboard-text-linear.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture dangerCircleBold = SvgPicture.asset(
    'assets/icons/danger-circle-bold.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture dangerCircleOutline = SvgPicture.asset(
    'assets/icons/danger-circle-outline.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture eyeLinear = SvgPicture.asset(
    'assets/icons/eye-linear.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture hamburgerMenuLinear = SvgPicture.asset(
    'assets/icons/hamburger-menu-linear.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture heartBold = SvgPicture.asset(
    'assets/icons/heart-bold.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture heartLinear = SvgPicture.asset(
    'assets/icons/heart-linear.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture homeOutline = SvgPicture.asset(
    'assets/icons/home-outline.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture infoCircleLinear = SvgPicture.asset(
    'assets/icons/info-circle-linear.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture logout2Outline = SvgPicture.asset(
    'assets/icons/logout-2-outline.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture qrCodeOutline = SvgPicture.asset(
    'assets/icons/qr-code-outline.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture roundAltArrowLeftLinear = SvgPicture.asset(
    'assets/icons/round-alt-arrow-left-linear.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture roundAltArrowRightLinear = SvgPicture.asset(
    'assets/icons/round-alt-arrow-right-linear.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture trashBinMinimalisticLinear = SvgPicture.asset(
    'assets/icons/trash-bin-minimalistic-linear.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture videoFramePlayHorizontalLinear = SvgPicture.asset(
    'assets/icons/video-frame-play-horizontal-linear.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture videocameraAddLinear = SvgPicture.asset(
    'assets/icons/videocamera-add-linear.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final SvgPicture checkCircleBold = SvgPicture.asset(
    'assets/icons/check-circle-bold.svg',
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    width: _sizeMap[size],
    height: _sizeMap[size],
  );

  late final Widget circle = Padding(
    padding: const EdgeInsets.all(2),
    child: SvgPicture.asset(
      'assets/icons/circle.svg',
      width: _sizeMap[size],
      height: _sizeMap[size],
    ),
  );
}

enum IconTokenSize { small, medium }
