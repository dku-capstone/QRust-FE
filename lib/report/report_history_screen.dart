import 'package:flutter/material.dart';
import 'package:qrust/widgets/upper_navbar.dart';
import 'package:qrust/widgets/drawer_menu.dart';
import 'package:qrust/api/report_history_api.dart';
import 'package:qrust/report/report_detail_screen.dart';

class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  List<Map<String, dynamic>> _allReports = [];
  List<Map<String, dynamic>> _visibleReports = [];
  bool _isLoading = true;
  bool _isFetchingMore = false;
  int _itemsPerPage = 10;
  int _currentPage = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchReports();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchReports() async {
    final reports = await ReportHistoryApi.fetchReportHistory();
    setState(() {
      _allReports = reports;
      _visibleReports = reports.take(_itemsPerPage).toList();
      _currentPage = 1;
      _isLoading = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !_isFetchingMore &&
        _visibleReports.length < _allReports.length) {
      _loadMoreReports();
    }
  }

  void _loadMoreReports() {
    setState(() => _isFetchingMore = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      final start = _currentPage * _itemsPerPage;
      final end = start + _itemsPerPage;
      final nextItems = _allReports.sublist(
        start,
        end.clamp(0, _allReports.length),
      );

      setState(() {
        _visibleReports.addAll(nextItems);
        _currentPage++;
        _isFetchingMore = false;
      });
    });
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case '승인됨':
        return Icons.check_circle;
      case '거부됨':
        return Icons.cancel;
      default:
        return Icons.hourglass_bottom;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '승인됨':
        return Colors.green;
      case '거부됨':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      backgroundColor: Colors.white,
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            NavigationAppBar(scaffoldKey: GlobalKey<ScaffoldState>()),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '신고 내역',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _visibleReports.isEmpty
                  ? const Center(child: Text("신고 내역이 없습니다."))
                  : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _visibleReports.length + (_isFetchingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _visibleReports.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final report = _visibleReports[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '악성 URL 신고',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          report['url'],
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              report['date'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  _getStatusIcon(report['status']),
                                  color: _getStatusColor(report['status']),
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  report['status'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(report['status']),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              final reportId = report['id'];
                              if (reportId != null) {
                                print('📦 이동할 reportId: $reportId');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ReportDetailScreen(reportId: reportId),
                                  ),
                                );
                              } else {
                                print('❌ reportId가 null입니다.');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 3,
                              backgroundColor: Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              '접수 내역 확인',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home/home_screen.dart',
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1AD282),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '홈으로',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
