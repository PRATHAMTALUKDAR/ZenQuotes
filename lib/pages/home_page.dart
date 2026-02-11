import 'package:flutter/material.dart';
import 'package:random_quotes/models/quote_model.dart';
import 'package:random_quotes/services/quote_service.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isDarkText = false;

  final QuoteService random_quote = QuoteService();

  int maxWords = 20;

  Quote? quote;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }


  Color bgColor(bool isDarkText){
    if(isDarkText){
      return Color(0XFF3C3C3C);
    }
    return Color(0xE7F4F4F4);
  }


  Color quoteColor(bool isDarkText){
    if(isDarkText){
      return Color(0xE7F4F4F4);
    }
    return Color(0XFF000000);
  }


  Color loadingColor(bool isDarkText){
    if(isDarkText){
      return Colors.white;
    }
    return Color(0XFF3C3C3C);
  }

  Future<void> fetchQuote() async {
  try {
    isLoading = true;
    setState(() {});

    final q = await random_quote.getQuote();
    if (q.content != null && q.content!.split(" ").length >= maxWords) {
      return fetchQuote();
    }

    setState(() {
      quote = q;
      isLoading = false;
    });
  } 
  catch (e) {
    print("ERROR: $e");
    setState(() {
      isLoading = false;
    });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            fetchQuote();
          }
          else if (details.primaryVelocity! < 0) {
            fetchQuote();
          }
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: loadingColor(isDarkText)))
            : quote == null
                ? const Text("Failed to load quote")
                : Padding(
                  padding: const EdgeInsets.only(left : 15,right:80.0,top: 140),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${quote!.content}",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 45,
                          fontFamily: 'morningDew',
                          fontWeight: FontWeight.bold,
                          color: quoteColor(isDarkText)),
                        ),
                        const SizedBox(height: 90),
                        Text(
                          "- ${quote!.author}",
                          style: const TextStyle(
                            fontSize: 35,
                            fontFamily: 'morningDew',
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9E9E9E)
                          ),
                        ),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.only(left:60.0,top: 100),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.light_mode_outlined, size: 25),
                              Switch(
                                value: isDarkText,
                                splashRadius: 5,
                                inactiveThumbColor: const Color.fromARGB(221, 46, 46, 46),
                                activeThumbColor: Color.fromARGB(255, 230, 230, 230),
                                onChanged: (value) {
                                  setState(() {
                                    isDarkText = value;
                                    // print(isDarkText);
                                  });
                                },
                              ),
                              const Icon(Icons.dark_mode_outlined, size: 25),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
      ),
      backgroundColor: bgColor(isDarkText),
    );
  }
}