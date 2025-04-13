import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Data Model.dart';

class NewsProvider extends ChangeNotifier {
  List<Article> _articles = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasMorePages = true;
  String _searchQuery = '';

  // Store cached search results (last 5 search results)
  final List<Map<String, dynamic>> _searchCache = [];

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasMorePages => _hasMorePages;
  String get searchQuery => _searchQuery;

  // Fetch latest news (no search)
  Future<void> fetchLatestNews() async {
    _articles = [];
    _currentPage = 1;
    _hasMorePages = true;
    _searchQuery = '';

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      const apiKey = 'a31a8a69decb4a0aba858a95689e4ddf';
      final url = 'https://newsapi.org/v2/top-headlines?country=us&page=$_currentPage&pageSize=20&apiKey=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _processApiResponse(data);
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search news with query and cache results
  Future<void> searchNews(String query, {bool refresh = true}) async {
    if (query.isEmpty) return;

    _searchQuery = query;
    if (refresh) {
      _articles = [];
      _currentPage = 1;
      _hasMorePages = true;
    }

    // Check if the result is cached
    final cachedResult = _getCachedSearchResult(query);
    if (cachedResult != null) {
      _processApiResponse(cachedResult);
      return;
    }

    if (!_hasMorePages) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      const apiKey = 'a31a8a69decb4a0aba858a95689e4ddf';
      final url = 'https://newsapi.org/v2/everything?q=$query&page=$_currentPage&pageSize=20&apiKey=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _cacheSearchResult(query, data); // Cache the search result
        _processApiResponse(data);
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Process API response and update articles
  void _processApiResponse(Map<String, dynamic> data) {
    if (data['status'] == 'ok') {
      final List<dynamic> articlesJson = data['articles'];
      final List<Article> fetchedArticles = articlesJson
          .map((article) => Article.fromJson(article))
          .toList();

      if (fetchedArticles.isEmpty) {
        _hasMorePages = false;
      } else {
        _articles.addAll(fetchedArticles);
        _currentPage++;
      }
    } else {
      throw Exception('API Error: ${data['message']}');
    }
  }

  // Cache the search result and limit to the last 5 results
  void _cacheSearchResult(String query, Map<String, dynamic> data) {
    // Check if the cache is full (more than 5 results)
    if (_searchCache.length >= 5) {
      _searchCache.removeAt(0); // Remove the oldest cache
    }

    // Add the new search result to the cache
    _searchCache.add({'query': query, 'data': data});
  }

  // Retrieve cached result for a given query
  Map<String, dynamic>? _getCachedSearchResult(String query) {
    for (var cached in _searchCache) {
      if (cached['query'] == query) {
        return cached['data'];
      }
    }
    return null; // Return null if no cached result found
  }

  // Load more articles for infinite scrolling
  void loadMore() {
    if (!_isLoading && _hasMorePages) {
      if (_searchQuery.isEmpty) {
        fetchLatestNewsNextPage();
      } else {
        searchNews(_searchQuery, refresh: false);
      }
    }
  }

  Future<void> fetchLatestNewsNextPage() async {
    if (!_hasMorePages || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      const apiKey = 'a31a8a69decb4a0aba858a95689e4ddf';
      final url = 'https://newsapi.org/v2/top-headlines?country=us&page=$_currentPage&pageSize=20&apiKey=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _processApiResponse(data);
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear search results and cache
  void clearSearch() {
    _articles = [];
    _searchQuery = '';
    _currentPage = 1;
    _hasMorePages = true;
    _errorMessage = '';
    _searchCache.clear(); // Clear the search cache
    notifyListeners();
    fetchLatestNews();
  }
}
