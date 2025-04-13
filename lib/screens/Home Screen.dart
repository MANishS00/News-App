import 'package:flutter/material.dart';
import 'package:news_articles_app/screens/error%20page.dart';
import 'package:news_articles_app/screens/setting%20page.dart';
import 'package:provider/provider.dart';

import '../providers/Management.dart';
import '../tabs/News Card Widget.dart';
import '../tabs/constrant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).fetchLatestNews();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      Provider.of<NewsProvider>(context, listen: false).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(
          tag: "logo",
          child: klogo,
        ),
        title: Text("News", style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.cancel_sharp : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
          ),
          Consumer<NewsProvider>(
            builder: (context, newsProvider, child) {
              return newsProvider.searchQuery.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  newsProvider.clearSearch();
                },
              )
                  : SizedBox.shrink();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            itemBuilder: (BuildContext context) {
              return {'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
        bottom: _isSearching
            ? PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    final query = _searchController.text.trim();
                    if (query.isNotEmpty) {
                      Provider.of<NewsProvider>(context, listen: false)
                          .searchNews(query);
                    }
                  },
                ),
                hintText: 'Search for news...',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 4),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ),
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  Provider.of<NewsProvider>(context, listen: false)
                      .searchNews(query);
                }
              },
            ),
          ),
        )
            : null,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final newsProvider = Provider.of<NewsProvider>(context, listen: false);
          if (newsProvider.searchQuery.isEmpty) {
            await newsProvider.fetchLatestNews();
          } else {
            await newsProvider.searchNews(newsProvider.searchQuery);
          }
        },
        child: Consumer<NewsProvider>(
          builder: (context, newsProvider, child) {
            if (newsProvider.errorMessage.isNotEmpty) {
              return _buildErrorState(newsProvider);
            }

            if (newsProvider.articles.isEmpty) {
              return newsProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Center(child: Text('No articles found'));
            }

            return Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: newsProvider.articles.length +
                      (newsProvider.hasMorePages ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < newsProvider.articles.length) {
                      return NewsCard(article: newsProvider.articles[index]);
                    } else {
                      return newsProvider.isLoading
                          ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                          : SizedBox.shrink();
                    }
                  },
                ),
                if (newsProvider.isLoading && newsProvider.articles.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(NewsProvider newsProvider) {
    return errorpage();
  }
}
