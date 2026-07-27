import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeInfo.dart';
import 'package:animeone/ui/component/AnimeInfoCard.dart';
import 'package:animeone/ui/page/settings.dart';
import 'package:flutter/material.dart';

class AnimeList extends StatefulWidget {
  const AnimeList({super.key});

  @override
  State<AnimeList> createState() => _AnimeListState();
}

class _AnimeListState extends State<AnimeList> {
  static GlobalData global = GlobalData();
  List<AnimeInfo> list = [];
  final all = global.getAnimeList();
  final quickFilters = global.getQuickFilters();
  String? _selectedFilter;
  String _searchText = '';
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.search, size: 32),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: const InputDecoration.collapsed(
                  hintText: '快速搜尋',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                ),
                autocorrect: false,
                autofocus: false,
                onChanged: (t) => _filterList(t),
              ),
            )
          ],
        ),
        actions: <Widget>[
          Ink.image(
            image: const AssetImage('lib/assets/icon/logo.png'),
            width: 64,
            height: 64,
            child: Tooltip(
              message: '關於AnimeOne',
              child: InkWell(
                onTap: () {
                  // Go to information page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(),
                    ),
                  );
                },
                child: null,
              ),
            ),
          ),
        ],
      ),
      body: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Column(
          children: [
            renderQuickFilter(),
            Expanded(
              child: renderBody(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _resetList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// render a list of quick filter
  Widget renderQuickFilter() {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            ...quickFilters.map((filter) {
              final selected = _selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                child: Tooltip(
                  message: '搜索 $filter 動畫',
                  child: ActionChip(
                    label: Text(filter),
                    labelPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    side: BorderSide(color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline),
                    backgroundColor: selected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15) : Colors.transparent,
                    onPressed: () {
                      if (selected) {
                        _selectedFilter = null;
                      } else {
                        _selectedFilter = filter;
                      }
                      _applyFilters();
                    },
                  ),
                ),
              );
            }),
          Tooltip(
            message: '重設整個列表',
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _resetList(),
            ),
          ),
        ],
      ),
      ),
    );
  }

  /// render body and deal with 0 result
  Widget renderBody() {
    if (list.isEmpty) {
      return const Center(
        child: Text('找不到任何東西 (´;ω;`)'),
      );
    } else {
      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return AnimeInfoCard(info: list[index], index: index);
        },
      );
    }
  }

  /// Filter list by string
  void _filterList(String t) {
    _searchText = t;
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      list = all.where((e) {
        if (_selectedFilter != null && !e.contains(_selectedFilter!)) return false;
        if (_searchText != '' && !e.contains(_searchText)) return false;
        return true;
      }).toList();
    });
  }

  /// Reset list to only 100 items
  void _resetList() {
    _selectedFilter = null;
    _searchText = '';
    _searchController.clear();
    setState(() {
      list = all;
    });
  }
}
