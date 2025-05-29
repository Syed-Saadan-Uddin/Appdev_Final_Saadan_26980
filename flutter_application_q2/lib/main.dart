import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemUiOverlayStyle

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
  ];

  final List<Map<String, dynamic>> _bankCardsData = [
    {
      'color': Color(0xFFF472B6), // Pink card
      'accountType': "World",
      'cardNumber': "5413 7502 3412 2455",
      'cardDetailsLine': "Account card",
    },
    {
      'color': Color(0xFF60A5FA), // Blue card
      'accountType': "Business",
      'cardNumber': "4000 1234 5678 9010",
      'cardDetailsLine': "Company card",
    },
    {
      'color': Color(0xFF34D399), // Green card
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
      padding: EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: isProminent
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15), // Slightly more opaque shadow
                  blurRadius: 18,                      // Increased blur
                  spreadRadius: 1,                       // Small spread
                  offset: Offset(0, 6),                // Adjusted offset for "below" feel
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
                margin: EdgeInsets.only(top: 10.0, bottom: 12.0),
                decoration: BoxDecoration(
                  color: Color(0xFFFBBF24),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Text(
                cardNumber,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
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
      extendBodyBehindAppBar: true, // Allows body gradient to go behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Make status bar transparent
          statusBarIconBrightness: Brightness.dark, // Dark icons for light status bar
          statusBarBrightness: Brightness.light, // For iOS consistency
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
            onPressed: () { /* Action for help */ },
          ),
          SizedBox(width: 4),
        ],
      ),
      body: Container(
        // This container provides the global gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFBCFE8), // Top color: A noticeable pink (like Tailwind Pink 200)
              Color(0xFFFDF2F8), // Mid color: A very light pink (like Tailwind Pink 50)
              Colors.white,      // Bottom color: Fades to white
            ],
            stops: [0.0, 0.35, 0.75], // Adjust stops for desired gradient spread
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea( // Ensures content is not obscured by status bar/notches when AppBar is transparent
          top: true, // Apply safe area to the top
          bottom: false, // Bottom safe area is handled by Scaffold typically
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10), // Initial spacing below AppBar (adjust if needed with SafeArea)
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
                              isProminent: (1.0 - scale) < 0.01, // More robust check for prominent
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
                        onPressed: () { /* Action for "Open all" */ },
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