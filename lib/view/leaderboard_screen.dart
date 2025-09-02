import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_case_ayo/comp/button/white_button.dart';
import 'package:test_case_ayo/comp/modal/bottomsheet_faq.dart';
import 'package:test_case_ayo/comp/modal/filter_category_bottomsheet.dart';
import 'package:test_case_ayo/comp/modal/filter_cabor_bottomsheet.dart';
import 'package:test_case_ayo/comp/modal/filter_location_bottomsheet.dart';
import 'package:test_case_ayo/comp/modal/filter_periode_bottomsheet.dart';
import 'package:test_case_ayo/comp/oval_paint.dart';
import 'package:test_case_ayo/data/leaderboard_cubit.dart';
import 'package:test_case_ayo/model/data_dummy.dart';
import 'package:test_case_ayo/model/leaderboard_model.dart';
import 'package:test_case_ayo/utils/constant.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool isSingle = false;
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();
  final ScrollController _scrollController = ScrollController();
  bool _showFullList = false;
  bool _isAtTop = false;

  @override
  void initState() {
    super.initState();
    context.read<LeaderboardCubit>().loadInitialData();
    _draggableController.addListener(() {
      setState(() {});
    });
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    // Jika scroll position di paling atas, tunjukkan semua data termasuk top 3
    if (_scrollController.position.pixels == 0) {
      if (!_isAtTop) {
        setState(() {
          _isAtTop = true;
          _showFullList = true;
        });
      }
    } else if (_scrollController.position.pixels > 50) {
      if (_isAtTop) {
        setState(() {
          _isAtTop = false;
          _showFullList = false;
        });
        // Scroll ke posisi dimana rank 4 mulai (setelah top 3)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(0);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _draggableController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUI.PRIMARY,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorUI.PRIMARY,
        centerTitle: true,
        leading: Icon(
          Icons.arrow_back_ios_new_outlined,
          size: 14,
          color: ColorUI.WHITE,
        ),
        title: BlocBuilder<LeaderboardCubit, LeaderboardState>(
          builder: (context, state) {
            if (state is LeaderboardInitial || state is LeaderboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LeaderboardError) {
              return Center(child: Text(state.message));
            } else if (state is LeaderboardLoaded) {
              return InkWell(
                onTap: () {
                  _showPeriodeBottomSheet(context, state.currentFilter);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.currentFilter,
                      textAlign: TextAlign.center,
                      style: TextStyleUI.SUBTITLE1.copyWith(
                        color: ColorUI.WHITE,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 5),
                    SvgPicture.asset(
                      "assets/icons/ic_select.svg",
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),

        actions: [
          InkWell(
            onTap: () {
              showPointRulesModal(context);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              child: SvgPicture.asset(
                "assets/icons/ic_faq.svg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<LeaderboardCubit, LeaderboardState>(
        builder: (context, state) {
          if (state is LeaderboardInitial || state is LeaderboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LeaderboardError) {
            return Center(child: Text(state.message));
          } else if (state is LeaderboardLoaded) {
            return _buildContent(context, state);
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, LeaderboardLoaded state) {
    if (state.isEmptyState) {
      return _buildEmptyState(state);
    }
    return _buildBody(context, state);
  }

  Widget _buildEmptyState(LeaderboardLoaded state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: CustomPaint(painter: OvalPainter())),
          Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showCaborBottomSheet(context, state.currentCabor);
                      },
                      child: _buildDropdown(value: state.currentCabor),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        _showCategoryBottomSheet(
                          context,
                          state.currentCategory,
                        );
                      },
                      child: _buildDropdown(value: state.currentCategory),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        _showLocationBottomSheet(
                          context,
                          state.selectedLocation,
                        );
                      },
                      child: _buildDropdown(value: state.selectedLocation),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/ic_empty.png",
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Leaderboard belum tersedia',
                      style: TextStyleUI.SUBTITLE1.copyWith(
                        color: ColorUI.WHITE,
                        fontWeight: FontUI.WEIGHT_SEMI_BOLD,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Jadilah yang pertama untuk memulai pertandingan dan raih posisi terbaikmu',
                      textAlign: TextAlign.center,
                      style: TextStyleUI.BODY2.copyWith(
                        color: ColorUI.WHITE,
                        fontWeight: FontUI.WEIGHT_REGULAR,
                      ),
                    ),
                    const SizedBox(height: 16),
                    WhiteButton(text: 'Mulai Tanding', onPressed: () {}),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, LeaderboardLoaded state) {
    // Urutkan semua data berdasarkan rank
    // final allUsers = List<LeaderboardItem>.from(state.leaderboard)
    //   ..sort((a, b) => a.rank.compareTo(b.rank));

    // // Ambil top 3 untuk podium
    // final topThree = allUsers.where((item) => item.rank <= 3).toList();

    final allUsers = List<LeaderboardItem>.from(state.leaderboard)
      ..sort((a, b) => a.rank.compareTo(b.rank));

    final topThree = allUsers.where((item) => item.rank <= 3).toList();

    // Cari data user untuk ditampilkan di card
    final userData = allUsers.firstWhere(
      (item) => item.isUser == true,
      orElse: () => LeaderboardItem(
        id: '0',
        name: 'User Not Found',
        username: "No User For This Filter",
        points: 0,
        rank: 0,
        location: '',
        type: '',
        category: '',
        season: '',
        imageUrl: "assets/icons/ic_avatar.png",
      ),
    );
    return Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: OvalPainter())),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //list
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showCaborBottomSheet(context, state.currentCabor);
                      },
                      child: _buildDropdown(value: state.currentCabor),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        _showCategoryBottomSheet(
                          context,
                          state.currentCategory,
                        );
                      },
                      child: _buildDropdown(value: state.currentCategory),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        _showLocationBottomSheet(
                          context,
                          state.selectedLocation,
                        );
                      },
                      child: _buildDropdown(value: state.selectedLocation),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              //CARD
              _buildUserCard(userData, state.currentCategory),
              //RANK
              const SizedBox(height: 20),
              // Podium section - hanya tampilkan jika ada data
              if (topThree.isNotEmpty) ...[
                const SizedBox(height: 20),
                Expanded(
                  // Gunakan Expanded untuk mengambil sisa space
                  flex: 2, // Adjust flex factor sesuai kebutuhan
                  child: _buildPodiumSection(topThree, state.currentCategory),
                ),
              ] else ...[
                // Tampilkan placeholder jika tidak ada podium
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'Tidak ada data podium untuk filter ini',
                    style: TextStyleUI.BODY2.copyWith(color: ColorUI.WHITE),
                  ),
                ),
              ],
            ],
          ),
        ),
        _buildLeaderboardItem(state),
      ],
    );
  }

  Widget _buildLeaderboardItem(LeaderboardLoaded state) {
    final allUsers = List<LeaderboardItem>.from(state.leaderboard)
      ..sort((a, b) => a.rank.compareTo(b.rank));

    return DraggableScrollableSheet(
      controller: _draggableController,
      initialChildSize: 0.25, // Tinggi awal 25% dari layar
      minChildSize: 0.25, // Tinggi minimum 25% dari layar
      maxChildSize: 0.75, // Tinggi maksimum 80% dari layar
      builder: (context, scrollController) {
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              if (scrollNotification.scrollDelta! > 0 && _showFullList) {
                setState(() {
                  _showFullList = false;
                });
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(0);
                  }
                });
              }
            }
            return false;
          },
          child: Container(
            decoration: BoxDecoration(
              color: ColorUI.WHITE,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle untuk drag
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // Daftar pemain
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: allUsers.length,
                    itemBuilder: (context, index) {
                      final user = allUsers[index];
                      final isDouble =
                          state.currentCategory.toLowerCase() == 'ganda';
                      final isCommunity =
                          state.currentCategory.toLowerCase() == 'komunitas';

                      // Skip top 3 jika tidak showFullList
                      if (!_showFullList && user.rank <= 3) {
                        return const SizedBox.shrink();
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? Colors.grey[50]
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  user.rank.toString(),
                                  style: TextStyleUI.BODY3.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontUI.WEIGHT_REGULAR,
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 8),
                                      if (isDouble)
                                        IntrinsicHeight(
                                          child: SizedBox(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.20,
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                // Avatar pertama
                                                Positioned(
                                                  left: 0,
                                                  child: CircleAvatar(
                                                    radius: 20,
                                                    child: user.imageUrl != null
                                                        ? Image.asset(
                                                            user.imageUrl!,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : SvgPicture.asset(
                                                            "assets/icons/ic_avatar.svg",
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                ),
                                                // Avatar kedua
                                                Positioned(
                                                  left: 20,
                                                  child: CircleAvatar(
                                                    radius: 20,
                                                    child:
                                                        user.imageUrl2 != null
                                                        ? Image.asset(
                                                            user.imageUrl2!,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : SvgPicture.asset(
                                                            "assets/icons/ic_avatar.svg",
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      else if (isCommunity)
                                        // Tampilan untuk komunitas
                                        CircleAvatar(
                                          radius: 20,
                                          child: Image.asset(
                                            user.imageUrl!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      else
                                        // Tampilan untuk tunggal
                                        CircleAvatar(
                                          radius: 20,
                                          child: user.imageUrl != null
                                              ? Image.asset(
                                                  user.imageUrl!,
                                                  fit: BoxFit.cover,
                                                )
                                              : SvgPicture.asset(
                                                  "assets/icons/ic_avatar.svg",
                                                  fit: BoxFit.cover,
                                                ),
                                        ),

                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: SizedBox(
                                          width: MediaQuery.of(
                                            context,
                                          ).size.width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                user.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              if (user.username != null &&
                                                  user.username!.isNotEmpty)
                                                Text(
                                                  user.username ?? "",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyleUI.CAPTION1
                                                      .copyWith(
                                                        fontWeight:
                                                            FontUI.WEIGHT_LIGHT,
                                                      ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (user.rank != 0 && user.rank > 0)
                                      Image.asset(
                                        "assets/icons/ic_arrow_up.png",
                                        fit: BoxFit.cover,
                                      )
                                    else if (user.rank != 0 && user.rank < 0)
                                      Image.asset(
                                        "assets/icons/ic_arrow_down.png",
                                        width: 16,
                                        height: 16,
                                        fit: BoxFit.cover,
                                      )
                                    else
                                      const SizedBox(height: 16),
                                    Text("${user.points.toString()} pts"),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            const Divider(height: 1, color: ColorUI.TEXT_INK10),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserCard(LeaderboardItem user, String category) {
    final isDouble = category.toLowerCase() == 'ganda';
    final isCommunity = category.toLowerCase() == 'komunitas';
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: ColorUI.WHITE,
            borderRadius: BorderRadius.circular(BorderUI.RADIUS_BUTTON),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isCommunity)
                // Tampilan untuk komunitas
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      child: Image.asset(
                        user.imageUrl ?? "assets/icons/ic_avatar.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: TextStyleUI.BODY2.copyWith(
                              color: ColorUI.TEXT_INK100,
                              fontWeight: FontUI.WEIGHT_REGULAR,
                            ),
                          ),
                          if (user.username != null)
                            Text(
                              user.username!,
                              style: TextStyleUI.CAPTION1.copyWith(
                                color: ColorUI.TEXT_INK80,
                                fontWeight: FontUI.WEIGHT_REGULAR,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ColorUI.PRIMARY,
                        borderRadius: BorderRadius.circular(
                          BorderUI.RADIUS_BUTTON,
                        ),
                      ),
                      child: Text(
                        "${user.points} pts",
                        style: TextStyleUI.BODY4.copyWith(
                          color: ColorUI.WHITE,
                          fontWeight: FontUI.WEIGHT_SEMI_BOLD,
                        ),
                      ),
                    ),
                  ],
                )
              else if (!isDouble)
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            child: Image.asset(
                              user.imageUrl ?? "assets/icons/ic_avatar.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    user.name,
                                    style: TextStyleUI.BODY2.copyWith(
                                      color: ColorUI.TEXT_INK100,
                                      fontWeight: FontUI.WEIGHT_REGULAR,
                                    ),
                                  ),
                                  Text(
                                    user.username ?? "",
                                    style: TextStyleUI.CAPTION1.copyWith(
                                      color: ColorUI.TEXT_INK80,
                                      fontWeight: FontUI.WEIGHT_REGULAR,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ColorUI.PRIMARY,
                        borderRadius: BorderRadius.circular(
                          BorderUI.RADIUS_BUTTON,
                        ),
                      ),
                      child: Text(
                        "${user.points} pts",
                        style: TextStyleUI.BODY4.copyWith(
                          color: ColorUI.WHITE,
                          fontWeight: FontUI.WEIGHT_SEMI_BOLD,
                        ),
                      ),
                    ),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntrinsicHeight(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.20,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // Avatar pertama
                                  Positioned(
                                    left: 0,
                                    child: CircleAvatar(
                                      radius: 20,
                                      child: Image.asset(
                                        user.imageUrl ??
                                            "assets/icons/ic_avatar.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  // Avatar kedua (sedikit ke kanan biar overlap)
                                  Positioned(
                                    left: 20, // atur supaya overlap
                                    child: CircleAvatar(
                                      radius: 20,
                                      child: Image.asset(
                                        user.imageUrl2 ??
                                            "assets/icons/ic_avatar.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    user.name,
                                    style: TextStyleUI.BODY2.copyWith(
                                      color: ColorUI.TEXT_INK100,
                                      fontWeight: FontUI.WEIGHT_REGULAR,
                                    ),
                                  ),
                                  if (user.username != null)
                                    Text(
                                      user.username!,
                                      style: TextStyleUI.CAPTION1.copyWith(
                                        color: ColorUI.TEXT_INK80,
                                        fontWeight: FontUI.WEIGHT_REGULAR,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ColorUI.PRIMARY,
                        borderRadius: BorderRadius.circular(
                          BorderUI.RADIUS_BUTTON,
                        ),
                      ),
                      child: Text(
                        "${user.points} pts",
                        style: TextStyleUI.BODY4.copyWith(
                          color: ColorUI.WHITE,
                          fontWeight: FontUI.WEIGHT_SEMI_BOLD,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: ColorUI.PRIMARY_DARK,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(BorderUI.RADIUS_BUTTON),
              bottomRight: Radius.circular(BorderUI.RADIUS_BUTTON),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: "Kamu ada di peringkat ",
                  style: TextStyleUI.CAPTION1.copyWith(
                    color: ColorUI.WHITE,
                    fontWeight: FontUI.WEIGHT_REGULAR,
                  ),
                  children: [
                    TextSpan(
                      text: "#${user.rank}, ",
                      style: TextStyleUI.CAPTION1.copyWith(
                        color: ColorUI.WHITE,
                        fontWeight: FontUI.WEIGHT_SEMI_BOLD,
                      ),
                    ),
                    TextSpan(
                      text: "bagikan yuk!",
                      style: TextStyleUI.CAPTION1.copyWith(
                        color: ColorUI.WHITE,
                        fontWeight: FontUI.WEIGHT_REGULAR,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: SvgPicture.asset(
                  "assets/icons/ic_share.svg",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPodiumSection(
    List<LeaderboardItem> topThree,
    String currentCategory,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Pastikan minimal height tertentu
        final availableHeight = max(constraints.maxHeight, 150.0);

        final podiumHeight1 = availableHeight * 1.0;
        final podiumHeight2 = availableHeight * 0.90;
        final podiumHeight3 = availableHeight * 0.85;
        return Container(
          height: availableHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Juara 2 (jika ada)
                  if (topThree.length >= 2)
                    Expanded(
                      child: _buildPodium(
                        topThree[1],
                        podiumHeight2,
                        false,
                        currentCategory,
                      ),
                    ),

                  // Juara 1 (jika ada)
                  if (topThree.isNotEmpty)
                    Expanded(
                      child: _buildPodium(
                        topThree[0],
                        podiumHeight1,
                        true,
                        currentCategory,
                      ),
                    ),

                  // Juara 3 (jika ada)
                  if (topThree.length >= 3)
                    Expanded(
                      child: _buildPodium(
                        topThree[2],
                        podiumHeight3,
                        false,
                        currentCategory,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdown({required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: ColorUI.WHITE,
        borderRadius: BorderRadius.circular(
          BorderUI.RADIUS_BUTTON,
        ), // sudut rounded
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyleUI.SUBTITLE2.copyWith(
              fontWeight: FontUI.WEIGHT_REGULAR,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, color: ColorUI.TEXT_INK100),
        ],
      ),
    );
  }

  Widget _buildPodium(
    LeaderboardItem item,
    double height,
    bool isWinner,
    String category,
  ) {
    final isDouble = category.toLowerCase() == 'ganda';
    final isCommunity = category.toLowerCase() == 'komunitas';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isCommunity)
          // Foto profil
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                child: Image.asset(
                  item.imageUrl ?? "assets/icons/ic_avatar.png",
                  fit: BoxFit.cover,
                ),
              ),
              isWinner == true
                  ? Positioned(
                      left: 0,
                      right: 0,
                      top: 30,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        child: SvgPicture.asset(
                          "assets/icons/ic_crown.svg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          )
        else if (isDouble)
          SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Avatar pertama
                Positioned(
                  left: 0,
                  child: CircleAvatar(
                    radius: 28,
                    child: item.imageUrl != null
                        ? Image.asset(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          )
                        : Image.asset(
                            "assets/icons/ic_avatar.png",
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                  ),
                ),
                // Avatar kedua
                Positioned(
                  left: 28,
                  child: CircleAvatar(
                    radius: 28,
                    child: item.imageUrl2 != null
                        ? Image.asset(
                            item.imageUrl2!,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          )
                        : Image.asset(
                            "assets/icons/ic_avatar.png",
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                  ),
                ),
                isWinner == true
                    ? Positioned(
                        left: 25,
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.asset(
                            "assets/icons/ic_crown.svg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          )
        else
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                child: item.imageUrl != null
                    ? Image.asset(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      )
                    : Image.asset(
                        "assets/icons/ic_avatar.png",
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
              ),
              isWinner == true
                  ? Positioned(
                      left: 0,
                      right: 0,
                      top: 30,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        child: SvgPicture.asset(
                          "assets/icons/ic_crown.svg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),

        // Nama
        Text(
          item.name,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),

        // Poin
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            item.points.toString(),
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Podium
        Container(
          alignment: Alignment.topCenter,
          width: 70,
          height: height,
          decoration: BoxDecoration(
            color: ColorUI.PRIMARY_DARK,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            item.rank.toString(),
            style: TextStyleUI.SUBTITLE1.copyWith(
              fontSize: 45,
              color: ColorUI.WHITE,
              fontWeight: FontUI.WEIGHT_SEMI_BOLD,
            ),
          ),
        ),
      ],
    );
  }

  void _showPeriodeBottomSheet(BuildContext context, String currentValue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterPeriodeBottomSheet(
        title: 'Periode',
        options: DummyData.periodeOptions,
        initialValue: currentValue,
        onSelected: (option) {
          context.read<LeaderboardCubit>().changeFilter('periode', option.name);
        },
      ),
    );
  }

  void _showCaborBottomSheet(BuildContext context, String currentValue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterCaborBottomSheet(
        title: 'Cabang Olahraga',
        options: DummyData.sportCategories,
        initialValue: currentValue,
        onSelected: (option) {
          context.read<LeaderboardCubit>().changeCabor(option.name);
        },
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context, String currentValue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterCategoryBottomSheet(
        title: 'Kategori',
        options: DummyData.kategoriOptions,
        initialValue: currentValue,
        onSelected: (option) {
          context.read<LeaderboardCubit>().changeCategory(option.name);
        },
      ),
    );
  }

  void _showLocationBottomSheet(BuildContext context, String currentValue) {
    print('Showing location bottom sheet with current value: $currentValue');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterLocationBottomSheet(
        title: 'Pilih Region',
        options: DummyData.locationOptions,
        initialValue: currentValue,
        onSelected: (option) {
          print('Location selected: ${option.name}');
          context.read<LeaderboardCubit>().changeLocation(option.name);
        },
      ),
    );
  }
}
