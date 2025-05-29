import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chards UI',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.pink,
      ),
      debugShowCheckedModeBanner: false,
      home: ChardsScreen(),
    );
  }
}

class ChardsScreen extends StatefulWidget {
  const ChardsScreen({super.key});

  @override
  _ChardsScreenState createState() => _ChardsScreenState();
}

class _ChardsScreenState extends State<ChardsScreen> {
  int _selectedIndex = 1;
  PageController? _pageController;
  double _currentPage = 0.0;
  int _initialCardIndex = 0;

  final List<Map<String, String>> transactions = [
    {'name': 'Netflix', 'date': '15 Dec 2024', 'amount': '\$15,48'},
    {'name': 'Spotify', 'date': '14 Dec 2024', 'amount': '\$19,90'},
    {'name': 'Netflix', 'date': '12 Dec 2024', 'amount': '\$15,48'},
    {'name': 'Netflix', 'date': '15 Dec 2024', 'amount': '\$15,48'},
    {'name': 'Spotify', 'date': '14 Dec 2024', 'amount': '\$19,90'},
    {'name': 'Netflix', 'date': '12 Dec 2024', 'amount': '\$15,48'},
    {'name': 'Netflix', 'date': '15 Dec 2024', 'amount': '\$15,48'},
    {'name': 'Spotify', 'date': '14 Dec 2024', 'amount': '\$19,90'},
    {'name': 'Netflix', 'date': '12 Dec 2024', 'amount': '\$15,48'},
  ];

  final List<Map<String, dynamic>> _bankCardsData = [
    {
      'color': Color(0xFFF472B6),
      'accountType': "World",
      'cardNumber': "5413 7502 3412 2455",
      'cardDetailsLine': "Account card",
    },
    {
      'color': Color(0xFF60A5FA),
      'accountType': "Business",
      'cardNumber': "4000 1234 5678 9010",
      'cardDetailsLine': "Company card",
    },
    {
      'color': Color(0xFF34D399),
      'accountType': "Savings",
      'cardNumber': "3782 822463 10005",
      'cardDetailsLine': "Personal account",
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = _initialCardIndex.toDouble();
    _pageController = PageController(
      initialPage: _initialCardIndex,
      viewportFraction: 0.82,
    );
    _pageController!.addListener(() {
      if (_pageController!.page != null) {
        setState(() {
          _currentPage = _pageController!.page!;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  static Widget _buildBankCard({
    required Color color,
    required String accountType,
    required String cardNumber,
    required String cardDetailsLine,
    bool isProminent = false,
  }) {
    return Container(
      // MODIFIED PADDING: Reduced top/bottom padding from 18 to 7 (saves 11+11=22px)
      padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: isProminent
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 18,
                  spreadRadius: 1,
                  offset: Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(accountType, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500)),
              Icon(Icons.wifi, color: Colors.white.withOpacity(0.95), size: 26),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 32,
                margin: EdgeInsets.only(bottom: 1.0), // Keep this from previous fix
                decoration: BoxDecoration(
                  color: Color(0xFFFBBF24),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              // Added a small SizedBox for spacing if card number is too close to chip
              // Adjust or remove if not needed after padding change.
              SizedBox(height: 4),
              Text(
                cardNumber,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19, // Consider reducing to 18 if problems persist and design allows
                    letterSpacing: 2.5,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                cardDetailsLine,
                style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
              ),
              Row(
                children: [
                  CircleAvatar(backgroundColor: Color(0xFFEB001B), radius: 15),
                  Transform.translate(
                    offset: Offset(-9, 0),
                    child: CircleAvatar(backgroundColor: Color(0xFFF79E1B), radius: 15),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
          ),
        ),
        title: Text(
          'Chards',
          style: TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Color(0xFF4B5563), size: 26),
            onPressed: () {},
          ),
          SizedBox(width: 4),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFBCFE8),
              Color(0xFFFDF2F8),
              Colors.white,
            ],
            stops: [0.0, 0.35, 0.75],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          top: true,
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                SizedBox(
                  height: 220,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _bankCardsData.length,
                    itemBuilder: (context, index) {
                      final cardData = _bankCardsData[index];
                      double scale = 1.0;

                      double difference = (_currentPage - index).abs();
                      const double nonProminentScale = 0.87;
                      if (difference > 0) {
                         scale = 1.0 - (difference * (1.0 - nonProminentScale));
                         scale = scale.clamp(nonProminentScale, 1.0);
                      }
                      double verticalMargin = (220 * (1 - scale)) / 2.5;

                      return Container(
                        child: Transform.scale(
                          scale: scale,
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: verticalMargin,
                            ),
                            child: _buildBankCard(
                              color: cardData['color'],
                              accountType: cardData['accountType'],
                              cardNumber: cardData['cardNumber'],
                              cardDetailsLine: cardData['cardDetailsLine'],
                              isProminent: (1.0 - scale) < 0.01,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Last activities',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Open all',
                          style: TextStyle(color: Color(0xFFF472B6), fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 7.0),
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Color(0xFFF3F4F6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.star_border, color: Color(0xFF6B7280), size: 22),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction['name']!,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  transaction['date']!,
                                  style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            transaction['amount']!,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card_outlined), activeIcon: Icon(Icons.credit_card), label: 'Cards'),
          BottomNavigationBarItem(icon: Icon(Icons.apps_outlined), activeIcon: Icon(Icons.apps), label: 'Pix'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), activeIcon: Icon(Icons.description), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Extract'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pinkAccent[700],
        unselectedItemColor: Color(0xFF6B7280),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10.0,
        onTap: _onItemTapped,
      ),
    );
  }
}