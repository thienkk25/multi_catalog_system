import 'package:flutter/material.dart';

/// Shows a custom date range picker bottom sheet.
/// Returns a [DateTimeRange] or null if cancelled.
Future<DateTimeRange?> showCustomDateRangePicker(BuildContext context) {
  return showModalBottomSheet<DateTimeRange>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _CustomDateRangePickerSheet(),
  );
}

class _CustomDateRangePickerSheet extends StatefulWidget {
  const _CustomDateRangePickerSheet();

  @override
  State<_CustomDateRangePickerSheet> createState() =>
      _CustomDateRangePickerSheetState();
}

class _CustomDateRangePickerSheetState
    extends State<_CustomDateRangePickerSheet> {
  late DateTime _currentMonth;
  DateTime? _startDate;
  DateTime? _endDate;

  /// null = calendar view, 'year' = year grid, 'month' = month grid
  String? _pickerMode;
  late int _selectedYear;

  static const _primaryColor = Color(0xFF1565C0);
  static const _accentColor = Color(0xFF42A5F5);

  final _weekDays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _selectedYear = _currentMonth.year;
  }

  void _onDayTap(DateTime day) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = day;
        _endDate = null;
      } else {
        if (day.isBefore(_startDate!)) {
          _endDate = _startDate;
          _startDate = day;
        } else {
          _endDate = day;
        }
      }
    });
  }

  void _applyPreset(DateTime start, DateTime end) {
    setState(() {
      _startDate = start;
      _endDate = end;
      _currentMonth = DateTime(start.year, start.month);
    });
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isInRange(DateTime day) {
    if (_startDate == null || _endDate == null) return false;
    return day.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
        day.isBefore(_endDate!.add(const Duration(days: 1)));
  }

  String _monthYearString(DateTime date) {
    const months = [
      'Tháng 1',
      'Tháng 2',
      'Tháng 3',
      'Tháng 4',
      'Tháng 5',
      'Tháng 6',
      'Tháng 7',
      'Tháng 8',
      'Tháng 9',
      'Tháng 10',
      'Tháng 11',
      'Tháng 12',
    ];
    return '${months[date.month - 1]}, ${date.year}';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 60),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildPresetChips(),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildMonthNavigation(),
            if (_pickerMode != null)
              _buildYearMonthPicker()
            else ...[
              _buildWeekdayLabels(),
              _buildCalendarGrid(),
            ],
            _buildFooter(),
            SizedBox(height: bottomPadding + 8),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor, _accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.date_range_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 10),
              const Text(
                'Chọn khoảng thời gian',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Từ ngày',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .7),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _startDate != null ? _formatDate(_startDate!) : '- - -',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white.withValues(alpha: .6),
                    size: 18,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Đến ngày',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .7),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _endDate != null ? _formatDate(_endDate!) : '- - -',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChips() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final presets = <String, DateTimeRange>{
      'Hôm nay': DateTimeRange(start: today, end: today),
      'Tuần này': DateTimeRange(
        start: today.subtract(Duration(days: today.weekday - 1)),
        end: today,
      ),
      'Tháng này': DateTimeRange(
        start: DateTime(today.year, today.month, 1),
        end: today,
      ),
      '7 ngày': DateTimeRange(
        start: today.subtract(const Duration(days: 6)),
        end: today,
      ),
      '30 ngày': DateTimeRange(
        start: today.subtract(const Duration(days: 29)),
        end: today,
      ),
      '90 ngày': DateTimeRange(
        start: today.subtract(const Duration(days: 89)),
        end: today,
      ),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: presets.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final label = presets.keys.elementAt(index);
            final range = presets.values.elementAt(index);

            final isActive =
                _startDate != null &&
                _endDate != null &&
                _isSameDay(_startDate!, range.start) &&
                _isSameDay(_endDate!, range.end);

            return GestureDetector(
              onTap: () => _applyPreset(range.start, range.end),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive ? _primaryColor : const Color(0xFFF0F4FA),
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: isActive ? _primaryColor : const Color(0xFFD8DEE8),
                    width: 1,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFF4A5568),
                    fontSize: 12.5,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMonthNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavButton(
            Icons.chevron_left_rounded,
            _pickerMode == 'year'
                ? () => setState(() => _selectedYear -= 12)
                : _previousMonth,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (_pickerMode == null) {
                  _pickerMode = 'year';
                  _selectedYear = _currentMonth.year;
                } else {
                  _pickerMode = null;
                }
              });
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Row(
                key: ValueKey(_pickerMode),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _pickerMode == 'year'
                        ? '${_selectedYear - 5} – ${_selectedYear + 6}'
                        : _pickerMode == 'month'
                        ? '$_selectedYear'
                        : _monthYearString(_currentMonth),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1B2838),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _pickerMode != null
                        ? Icons.calendar_month_rounded
                        : Icons.arrow_drop_down_rounded,
                    size: 20,
                    color: _primaryColor,
                  ),
                ],
              ),
            ),
          ),
          _buildNavButton(
            Icons.chevron_right_rounded,
            _pickerMode == 'year'
                ? () => setState(() => _selectedYear += 12)
                : _nextMonth,
          ),
        ],
      ),
    );
  }

  Widget _buildYearMonthPicker() {
    if (_pickerMode == 'year') {
      return _buildYearGrid();
    }
    return _buildMonthGrid();
  }

  Widget _buildYearGrid() {
    final currentYear = DateTime.now().year;
    final startYear = _selectedYear - 5;
    final years = List.generate(12, (i) => startYear + i);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.2,
        ),
        itemCount: years.length,
        itemBuilder: (context, index) {
          final year = years[index];
          final isCurrentYear = year == currentYear;
          final isSelected = year == _currentMonth.year;

          return Material(
            color: isSelected
                ? _primaryColor
                : isCurrentYear
                ? _accentColor.withValues(alpha: .12)
                : const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedYear = year;
                  _pickerMode = 'month';
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: Center(
                child: Text(
                  '$year',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected || isCurrentYear
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : isCurrentYear
                        ? _primaryColor
                        : const Color(0xFF4A5568),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthGrid() {
    const monthNames = [
      'Th1',
      'Th2',
      'Th3',
      'Th4',
      'Th5',
      'Th6',
      'Th7',
      'Th8',
      'Th9',
      'Th10',
      'Th11',
      'Th12',
    ];
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.2,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = index + 1;
          final isCurrentMonth =
              _selectedYear == now.year && month == now.month;
          final isSelected =
              _selectedYear == _currentMonth.year &&
              month == _currentMonth.month;

          return Material(
            color: isSelected
                ? _primaryColor
                : isCurrentMonth
                ? _accentColor.withValues(alpha: .12)
                : const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {
                setState(() {
                  _currentMonth = DateTime(_selectedYear, month);
                  _pickerMode = null;
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: Center(
                child: Text(
                  monthNames[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected || isCurrentMonth
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : isCurrentMonth
                        ? _primaryColor
                        : const Color(0xFF4A5568),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: const Color(0xFFF0F4FA),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 22, color: _primaryColor),
        ),
      ),
    );
  }

  Widget _buildWeekdayLabels() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _weekDays.map((day) {
          final isWeekend = day == 'T7' || day == 'CN';
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isWeekend
                      ? const Color(0xFFE57373)
                      : _primaryColor.withValues(alpha: .6),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateUtils.getDaysInMonth(
      _currentMonth.year,
      _currentMonth.month,
    );
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    // Monday = 1, so offset = weekday - 1
    final startOffset = (firstDayOfMonth.weekday - 1) % 7;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final totalCells = startOffset + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: List.generate(rowCount, (row) {
          return Row(
            children: List.generate(7, (col) {
              final index = row * 7 + col;
              if (index < startOffset || index >= startOffset + daysInMonth) {
                return const Expanded(child: SizedBox(height: 42));
              }

              final day = DateTime(
                _currentMonth.year,
                _currentMonth.month,
                index - startOffset + 1,
              );

              final isToday = _isSameDay(day, todayDate);
              final isStart =
                  _startDate != null && _isSameDay(day, _startDate!);
              final isEnd = _endDate != null && _isSameDay(day, _endDate!);
              final isInRange = _isInRange(day);
              final isSelected = isStart || isEnd;
              final isWeekend = col == 5 || col == 6;

              Color bgColor = Colors.transparent;
              Color textColor = isWeekend
                  ? const Color(0xFFE57373)
                  : const Color(0xFF2D3748);
              FontWeight fontWeight = FontWeight.w500;
              BoxDecoration? decoration;

              if (isSelected) {
                bgColor = _primaryColor;
                textColor = Colors.white;
                fontWeight = FontWeight.w700;
                decoration = BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_primaryColor, _accentColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withValues(alpha: .3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                );
              } else if (isInRange) {
                bgColor = _accentColor.withValues(alpha: .12);
                textColor = _primaryColor;
                fontWeight = FontWeight.w600;
              } else if (isToday) {
                fontWeight = FontWeight.w700;
                textColor = _primaryColor;
              }

              return Expanded(
                child: GestureDetector(
                  onTap: () => _onDayTap(day),
                  child: Container(
                    height: 42,
                    margin: EdgeInsets.only(
                      left: isInRange && !isStart ? 0 : 2,
                      right: isInRange && !isEnd ? 0 : 2,
                      top: 2,
                      bottom: 2,
                    ),
                    decoration:
                        decoration ??
                        BoxDecoration(
                          color: bgColor,
                          borderRadius: isStart && isInRange
                              ? const BorderRadius.horizontal(
                                  left: Radius.circular(12),
                                )
                              : isEnd && isInRange
                              ? const BorderRadius.horizontal(
                                  right: Radius.circular(12),
                                )
                              : isInRange
                              ? null
                              : BorderRadius.circular(12),
                          border: isToday && !isSelected
                              ? Border.all(color: _primaryColor, width: 1.5)
                              : null,
                        ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: fontWeight,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildFooter() {
    final canConfirm = _startDate != null && _endDate != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _startDate = null;
                  _endDate = null;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF64748B),
                side: const BorderSide(color: Color(0xFFD8DEE8)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Xóa',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: ElevatedButton(
                onPressed: canConfirm
                    ? () => Navigator.pop(
                        context,
                        DateTimeRange(start: _startDate!, end: _endDate!),
                      )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  disabledBackgroundColor: const Color(0xFFE2E8F0),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: const Color(0xFF94A3B8),
                  elevation: canConfirm ? 3 : 0,
                  shadowColor: _primaryColor.withValues(alpha: .3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 18,
                      color: canConfirm
                          ? Colors.white
                          : const Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Xác nhận',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: canConfirm
                            ? Colors.white
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
