enum CustomDateFormat {
  fullDate('MMMM d, y'),            // January 1, 2025
  shortDate('MM/dd/yyyy'),          // 01/01/2025
  timeOnly('h:mm a'),               // 5:00 AM
  dateTime('MMM d, y h:mm a'),      // Jan 1, 2025 5:00 AM
  yearMonth('MMMM yyyy'),           // January 2025
  iso8601("yyyy-MM-dd'T'HH:mm:ss"), // 2025-01-01T05:00:00
  simpleDate('d MMMM y'), // 13 October 2025
  hijriDate('d, MMMM yyyy'); // 13, October 1447


  final String value;

  const CustomDateFormat(this.value);
}