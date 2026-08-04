import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeInfo.dart';
import 'package:animeone/l10n/app_localizations.dart';
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
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 20),
                decoration: InputDecoration.collapsed(
                  hintText: AppLocalizations.of(context)!.quickSearch,
                  hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 20),
                ),
                autocorrect: false,
                autofocus: false,
                onChanged: (t) => _filterList(t),
              ),
            )
          ],
        ),
        actions: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              // Go to information page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Settings(),
                ),
              );
            },
            child: Tooltip(
              message: AppLocalizations.of(context)!.aboutAnimeOne,
              child: SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: Ink.image(
                    image: const AssetImage('lib/assets/icon/logo.png'),
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                    width: 32,
                    height: 32,
                  ),
                ),
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
    final quickFilters = global.getQuickFilters(AppLocalizations.of(context)!);
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            ...quickFilters.map((f) {
              final selected = _selectedFilter == f.value;
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                child: Tooltip(
                  message: AppLocalizations.of(context)!.searchFilter(f.label),
                  child: ActionChip(
                    label: Text(f.label),
                    labelPadding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    side: BorderSide(
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline),
                    backgroundColor: selected
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.15)
                        : Colors.transparent,
                    onPressed: () {
                      if (selected) {
                        _selectedFilter = null;
                      } else {
                        _selectedFilter = f.value;
                      }
                      _applyFilters();
                    },
                  ),
                ),
              );
            }),
            Tooltip(
              message: AppLocalizations.of(context)!.resetList,
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
      return Center(
        child: Text(AppLocalizations.of(context)!.notFound),
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
        final selected = _selectedFilter;
        if (selected != null && !e.contains(selected)) {
          return false;
        }
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
