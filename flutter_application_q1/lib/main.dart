import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;

import 'firebase_options.dart'; 

class BannerItem {
  final String id;
  final String titleShopWith; 
  final String titlePercent;  
  final String titleCashback; 
  final String subtitle;      
  final String buttonText;
  final String offerText;
  final String imageUrl;

  BannerItem({
    required this.id,
    required this.titleShopWith,
    required this.titlePercent,
    required this.titleCashback,
    required this.subtitle,
    required this.buttonText,
    required this.offerText,
    required this.imageUrl,
  });

  factory BannerItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return BannerItem(
      id: doc.id,
      titleShopWith: data['titleShopWith'] ?? ' ',
      titlePercent: data['titlePercent'] ?? ' ',
      titleCashback: data['titleCashback'] ?? ' ',
      subtitle: data['subtitle'] ?? ' ',
      buttonText: data['buttonText'] ?? ' ',
      offerText: data['offerText'] ?? ' ',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}

class CategoryItem {
  final String id;
  final String name;
  final String iconName;

  CategoryItem({required this.id, required this.name, required this.iconName});

  factory CategoryItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return CategoryItem(
      id: doc.id,
      name: data['name'] ?? ' ',
      iconName: data['iconName'] ?? ' ',
    );
  }
}

class ProductItem {
  final String id;
  final String name;
  final String imageUrl;
  final String cashback;
  final bool isFavorite;
  final String subName;

  ProductItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.cashback,
    this.isFavorite = false,
    this.subName = "",
  });

  factory ProductItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProductItem(
      id: doc.id,
      name: data['cashback'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      cashback: data['name'] ?? ' ',
      subName: data['subName'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
    );
  }
}



abstract class BannerState {}
class BannerInitial extends BannerState {}
class BannerLoading extends BannerState {}
class BannerLoaded extends BannerState {
  final List<BannerItem> banners;
  BannerLoaded(this.banners);
}
class BannerError extends BannerState {
  final String message;
  BannerError(this.message);
}

class BannerCubit extends Cubit<BannerState> {
  BannerCubit() : super(BannerInitial());
  Future<void> fetchBanners() async {
    emit(BannerLoading());
    if (Firebase.apps.isEmpty) {
      emit(BannerError("Banners: Firebase not initialized."));
      return;
    }
    try {
      final snapshot = await FirebaseFirestore.instance.collection('banners').limit(1).get();
      if (snapshot.docs.isEmpty) {
        emit(BannerError("Banners: No data found for the main banner."));
        return;
      }
      final banners = snapshot.docs.map((doc) => BannerItem.fromFirestore(doc)).toList();
      emit(BannerLoaded(banners));
    } catch (e) {
      emit(BannerError("Banners: Failed to load. Error: ${e.toString()}"));
    }
  }
}

abstract class CategoryState {}
class CategoryInitial extends CategoryState {}
class CategoryLoading extends CategoryState {}
class CategoryLoaded extends CategoryState {
  final List<CategoryItem> categories;
  CategoryLoaded(this.categories);
}
class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());
  Future<void> fetchCategories() async {
    emit(CategoryLoading());
     if (Firebase.apps.isEmpty) {
      emit(CategoryError("Categories: Firebase not initialized."));
      return;
    }
    try {
      final snapshot = await FirebaseFirestore.instance.collection('categories').limit(5).get();
      if (snapshot.docs.isEmpty) {
        emit(CategoryError("Categories: No data found."));
        return;
      }
      final categories = snapshot.docs.map((doc) => CategoryItem.fromFirestore(doc)).toList();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError("Categories: Failed to load. Error: ${e.toString()}"));
    }
  }
}

abstract class PopularProductState {}
class PopularProductInitial extends PopularProductState {}
class PopularProductLoading extends PopularProductState {}
class PopularProductLoaded extends PopularProductState {
  final List<ProductItem> products;
  PopularProductLoaded(this.products);
}
class PopularProductError extends PopularProductState {
  final String message;
  PopularProductError(this.message);
}

class PopularProductCubit extends Cubit<PopularProductState> {
  PopularProductCubit() : super(PopularProductInitial());
  Future<void> fetchPopularProducts() async {
    emit(PopularProductLoading());
    if (Firebase.apps.isEmpty) {
      emit(PopularProductError("Products: Firebase not initialized."));
      return;
    }
    try {
      final snapshot = await FirebaseFirestore.instance.collection('popular_products').get();
       if (snapshot.docs.isEmpty) {
        emit(PopularProductError("Products: No data found."));
        return;
      }
      final products = snapshot.docs.map((doc) => ProductItem.fromFirestore(doc)).toList();
      emit(PopularProductLoaded(products));
    } catch (e) {
      emit(PopularProductError("Products: Failed to load. Error: ${e.toString()}"));
    }
  }
}



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully in Flutter app!");
  } catch (e) {
    print("!!!!!!!! Firebase initialization FAILED in Flutter app !!!!!!!!");
    print("Error: ${e.toString()}");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BannerCubit()..fetchBanners()),
        BlocProvider(create: (context) => CategoryCubit()..fetchCategories()),
        BlocProvider(create: (context) => PopularProductCubit()..fetchPopularProducts()),
      ],
      child: MaterialApp(
        title: 'Shopping App',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          primaryColor: const Color(0xFFF06292),
          fontFamily: 'Inter',
          scaffoldBackgroundColor: Colors.transparent,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'percent': case 'earn 100%': return Icons.percent_outlined;
      case 'description_outlined': case 'tax note': return Icons.description_outlined;
      case 'diamond_outlined': case 'primum': return Icons.diamond_outlined;
      case 'emoji_events_outlined': case 'challenge': case 'gamepad_outlined' : return Icons.gamepad_outlined;
      case 'more_horiz': case 'more': return Icons.more_horiz;
      default: return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEAC0EA),
              Color(0xFFFDECF4),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.6]
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildProfileHeader(),
              _buildSearchBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategoryList(),
                      const SizedBox(height: 24),
                      _buildCashbackBannerSection(), 
                      const SizedBox(height: 24),
                      _buildPopularOffersSection(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade300)
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: TextStyle(color: Colors.red.shade900))),
        ],
      ),
    );
  }

  Widget _buildCircularIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.pink.shade300.withOpacity(0.8),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22),
        onPressed: onPressed,
        splashRadius: 20,
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: CachedNetworkImageProvider('https://randomuser.me/api/portraits/men/32.jpg'),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Wilson Junior', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
              Text('Premium', style: TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
          const Spacer(),
          _buildCircularIconButton(Icons.card_giftcard, () {}),
          _buildCircularIconButton(Icons.notifications, () {}),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 6.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey.shade700),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                  border: InputBorder.none,
                ),
                readOnly: true,
                onTap: () {},
              ),
            ),
             Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.pink.shade300.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.tune, color: Colors.white, size: 20),
                onPressed: () {},
                splashRadius: 20,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
        } else if (state is CategoryLoaded) {
          return Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical:10.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: state.categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.75),
                          shape: BoxShape.circle,
                           border: Border.all(color: Colors.grey.shade300, width: 0.5)
                        ),
                        child: Icon(
                          _getIconData(category.iconName),
                          color: Colors.grey.shade800,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category.name,
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else if (state is CategoryError) {
          return _buildErrorWidget(state.message);
        }
        return const SizedBox(height: 100, child: Center(child: Text('Initializing categories...')));
      },
    );
  }

  
  Widget _buildCashbackBannerSection() {
    return BlocBuilder<BannerCubit, BannerState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          return const SizedBox(height: 180, child: Center(child: CircularProgressIndicator()));
        } else if (state is BannerLoaded && state.banners.isNotEmpty) {
          final banner = state.banners.first;
          
          const double headphoneRightOffset = -30; 
          const double headphoneTopOffset = -30;
          const double headphoneWidth = 180;
          const double headphoneHeight = 180;
          const double headphoneRotationAngle = 0.22;

          
          const Color sketchPinkZone = Color(0xFFF8BBD0);     
          const Color sketchLightPinkZone = Color(0xFFFFF0F5);  
          const Color sketchLightBlueZone = Color(0xFFAEDFF7);  
          const Color sketchGreyZone = Color(0xFFE0E0E0);        
          const Color sketchBlueRightZone = Color(0xFF90CAF9);  

          
          const Color darkPinkForText = Color(0xFFD81B60); 
          const Color buttonColor = Color(0xFFF06292);

          double bannerCardHeight = 160.0;
          double totalHeightForStack = bannerCardHeight;
          if (headphoneTopOffset < 0) {
            totalHeightForStack = bannerCardHeight + (headphoneTopOffset.abs() * 0.85);
          }
          
          
          const TextStyle shopWithStyle = TextStyle(fontSize: 17, color: Color.fromARGB(255, 0, 0, 0), fontFamily: 'Inter', fontWeight: FontWeight.w500, height: 1.25);
          const TextStyle percentStyle = TextStyle(fontSize: 17, color: darkPinkForText, fontFamily: 'Inter', fontWeight: FontWeight.w800, height: 1.25);
          const TextStyle cashbackStyle = TextStyle(fontSize: 17, color: Color.fromARGB(255, 0, 0, 0), fontFamily: 'Inter', fontWeight: FontWeight.w500, height: 1.25);
          const TextStyle onShopeeStyle = TextStyle(fontSize: 12.5, color: Color.fromARGB(255, 48, 45, 45), fontWeight: FontWeight.w500, height: 1.3);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  '100 cashback',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: totalHeightForStack,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topLeft,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: (headphoneTopOffset < 0) ? headphoneTopOffset.abs() : 0,
                      height: bannerCardHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                             
                              sketchLightBlueZone,
                              sketchPinkZone, 
                              const Color.fromARGB(255, 190, 224, 252),  
                              const Color.fromARGB(255, 212, 206, 206),        
                              const Color.fromARGB(255, 255, 135, 175),    
                            ],
                            stops: const [
                              0.0,  
                              0.22, 
                              0.45, 
                              0.70, 
                              1.0,  
                            ],
                            
                            begin: const Alignment(-1.0, 0.8), 
                            end: const Alignment(1.0, -0.8),   
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.20),
                              spreadRadius: 0.5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0, top: 18.0, right: 16.0, bottom: 14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(text: "${banner.titleShopWith} ", style: shopWithStyle),
                                        TextSpan(text: banner.titlePercent, style: percentStyle),
                                      ],
                                    ),
                                  ),
                                  Text(banner.titleCashback, style: cashbackStyle),
                                  const SizedBox(height: 4),
                                  Text(banner.subtitle, style: onShopeeStyle),
                                ],
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      elevation: 1,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(banner.buttonText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.5)),
                                        const SizedBox(width: 5),
                                        const Icon(Icons.arrow_forward, color: Colors.white, size: 17),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(banner.offerText, style: TextStyle(fontSize: 12.5, color: const Color.fromARGB(255, 41, 40, 40).withOpacity(0.95), fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: headphoneRightOffset,
                      top: headphoneTopOffset,
                      width: headphoneWidth,
                      height: headphoneHeight,
                      child: Transform.rotate(
                        angle: headphoneRotationAngle,
                        child: CachedNetworkImage(
                          imageUrl: banner.imageUrl,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const SizedBox.shrink(),
                          errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.white54),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        } else if (state is BannerError) {
          return _buildErrorWidget(state.message);
        }
        return const SizedBox(height: 180, child: Center(child: Text('Initializing banner...')));
      },
    );
  }

  Widget _buildPopularOffersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Most popular offer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See all',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<PopularProductCubit, PopularProductState>(
          builder: (context, state) {
            if (state is PopularProductLoading) {
              return const SizedBox(height: 220, child: Center(child: CircularProgressIndicator()));
            } else if (state is PopularProductLoaded) {
              return SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.products.length,
                  padding: const EdgeInsets.only(left: 20, right: 8),
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return _buildProductCard(product);
                  },
                ),
              );
            } else if (state is PopularProductError) {
              return _buildErrorWidget(state.message);
            }
            return const SizedBox(height: 220, child: Center(child: Text('Initializing products...')));
          },
        ),
      ],
    );
  }

  Widget _buildProductCard(ProductItem product) {
    return Container(
      width: 155,
      margin: const EdgeInsets.only(right: 12.0, bottom: 8.0, top: 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).primaryColor))),
                    errorWidget: (context, url, error) => const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                    color: product.isFavorite ? Colors.pink.shade400 : Colors.black54,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.currency_exchange_outlined,
                      color: Colors.grey.shade700,
                      size: 15,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  product.cashback,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                 if (product.subName.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    product.subName,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 15,
             offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        )
      ),
      child: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xFF212121),
        unselectedItemColor: Colors.grey.shade500,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_bottomNavIndex == 0 ? Icons.home : Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(_bottomNavIndex == 1 ? Icons.credit_card : Icons.credit_card_outlined),
            label: 'Cards',
          ),
          BottomNavigationBarItem(
            icon: Icon(_bottomNavIndex == 2 ? Icons.apps : Icons.apps_outlined),
            label: 'Pix',
          ),
          BottomNavigationBarItem(
            icon: Icon(_bottomNavIndex == 3 ? Icons.description : Icons.description_outlined),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(_bottomNavIndex == 4 ? Icons.receipt_long : Icons.receipt_long_outlined),
            label: 'Extract',
          ),
        ],
      ),
    );
  }
}
