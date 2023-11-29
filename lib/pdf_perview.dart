import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pdf_wid;

pdf_wid.Font? arFont;

class OutcomePdfPrev extends StatefulWidget {
  final String outcomeName;
  final String outcomeTo;
  final String thatAbout;
  final String amount;

  const OutcomePdfPrev(
      {super.key,
      required this.outcomeName,
      required this.outcomeTo,
      required this.thatAbout,
      required this.amount});

  @override
  State<OutcomePdfPrev> createState() => _OutcomePdfPrevState();
}

class _OutcomePdfPrevState extends State<OutcomePdfPrev> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        build: (format) => _createOutcomePdf(
          format,
          widget.outcomeName,
          widget.outcomeTo,
          widget.thatAbout,
          widget.amount,
        ),
      ),
    );
  }
}

Future<Uint8List> _createOutcomePdf(
  PdfPageFormat format,
  final String outcomeName,
  final String outcomeTo,
  final String thatAbout,
  final String amount,
) async {
  final pdf = pdf_wid.Document(
    version: PdfVersion.pdf_1_4,
    compress: true,
  );
  var arabicFont =
      pdf_wid.Font.ttf(await rootBundle.load("assets/fonts/Amiri-Bold.ttf"));
  pdf.addPage(
    pdf_wid.Page(
      theme: pdf_wid.ThemeData.withFont(base: arabicFont),
      pageFormat: PdfPageFormat.roll80,
      //pageFormat: format,
      build: (context) {
        return pdf_wid.Row(
            mainAxisAlignment: pdf_wid.MainAxisAlignment.end,
            children: [
              pdf_wid.Column(
                  crossAxisAlignment: pdf_wid.CrossAxisAlignment.end,
                  children: [
                    pdf_wid.Text(
                      'اسم المصروف : $outcomeName',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'منصرف الي : $outcomeTo',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'وذلك عن : $thatAbout',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'المبلغ : $amount',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'التوقيع : ',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                  ]),
            ]);
      },
    ),
  );
  PermissionStatus storagePermissionStatus = await Permission.storage.status;
  if (storagePermissionStatus != PermissionStatus.granted) {
    PermissionStatus requestedPermissionStatus =
        await Permission.storage.request();

    // If the user granted the permission, download the file
    if (requestedPermissionStatus == PermissionStatus.granted) {
      final time = DateTime.now();
      final file =
          File("/storage/emulated/0/Download/outcome_$outcomeName.pdf");
      await file.writeAsBytes(await pdf.save());
      return pdf.save();
    } else {
      // The user did not grant the permission
      debugPrint('Permission to write to external storage was denied');
    }
  } else {
    final time = DateTime.now();
    final file = File("/storage/emulated/0/Download/outcome_$outcomeName.pdf");
    await file.writeAsBytes(await pdf.save());
    return pdf.save();
  }
  final time = DateTime.now();
  final file = File("/storage/emulated/0/Download/outcome_$outcomeName.pdf");
  await file.writeAsBytes(await pdf.save());
  return pdf.save();
}

class PdfPrev extends StatefulWidget {
  final String hotelName;
  final String clientName;
  final String nationality;
  final String clientId;
  final String clientNumber;
  final String roomNumber;
  final String startDate;
  final String endDate;
  final String amountPaid;
  final String amountRest;
  final String amountTotal;

  const PdfPrev(
      {super.key,
      required this.hotelName,
      required this.clientName,
      required this.nationality,
      required this.clientId,
      required this.clientNumber,
      required this.roomNumber,
      required this.startDate,
      required this.endDate,
      required this.amountPaid,
      required this.amountRest,
      required this.amountTotal});

  @override
  State<PdfPrev> createState() => _PdfPrevState();
}

class _PdfPrevState extends State<PdfPrev> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        build: (format) => _createPdf(
          format,
          widget.hotelName,
          widget.clientName,
          widget.nationality,
          widget.clientId,
          widget.clientNumber,
          widget.roomNumber,
          widget.startDate,
          widget.endDate,
          widget.amountPaid,
          widget.amountRest,
          widget.amountTotal,
        ),
      ),
    );
  }
}

Future<Uint8List> _createPdf(
  PdfPageFormat format,
  final String hotelName,
  final String clientName,
  final String nationality,
  final String clientId,
  final String clientNumber,
  final String roomNumber,
  final String startDate,
  final String endDate,
  final amountPaid,
  String amountRest,
  String amountTotal,
) async {
  final pdf = pdf_wid.Document(
    version: PdfVersion.pdf_1_4,
    compress: true,
  );
  var arabicFont =
      pdf_wid.Font.ttf(await rootBundle.load("assets/fonts/Amiri-Bold.ttf"));
  pdf.addPage(
    pdf_wid.Page(
      theme: pdf_wid.ThemeData.withFont(base: arabicFont),
      pageFormat: PdfPageFormat.roll80,
      //pageFormat: format,
      build: (context) {
        return pdf_wid.Row(
            mainAxisAlignment: pdf_wid.MainAxisAlignment.end,
            children: [
              pdf_wid.Column(
                  crossAxisAlignment: pdf_wid.CrossAxisAlignment.end,
                  children: [
                    pdf_wid.Text(
                      'اسم الفندق : $hotelName',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'اسم العميل : $clientName',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'الجنسية : $nationality',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'رقم الهوية : $clientId',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'رقم العميل : $clientNumber',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text('رقم الغرفة : $roomNumber',
                        textDirection: pdf_wid.TextDirection.rtl),
                    pdf_wid.Text(
                      'تاريخ بداية الحجز : $startDate',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'تاريخ نهاية الحجز : $endDate',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'المبلغ الكلي : $amountTotal',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'المبلغ المدفوع : $amountPaid',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'المبلغ الباقي : $amountRest',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                  ]),
            ]);
      },
    ),
  );
  PermissionStatus storagePermissionStatus = await Permission.storage.status;

  // If the app does not have the permission, request it from the user
  if (storagePermissionStatus != PermissionStatus.granted) {
    PermissionStatus requestedPermissionStatus =
        await Permission.storage.request();

    // If the user granted the permission, download the file
    if (requestedPermissionStatus == PermissionStatus.granted) {
      final time = DateTime.now();
      final file =
          File("/storage/emulated/0/Download/reservation_$clientId.pdf");
      await file.writeAsBytes(await pdf.save());

      return pdf.save();
    } else {
      // The user did not grant the permission
      debugPrint('Permission to write to external storage was denied');
    }
  } else {
    final file = File("/storage/emulated/0/Download/reservation_$clientId.pdf");
    await file.writeAsBytes(await pdf.save());

    return pdf.save();
  }
  return pdf.save();
}

class HotelPdfPrev extends StatefulWidget {
  final String hotelName;
  final String roomNumber;
  final String roomAvailable;
  final String roomReserved;
  final String maintenanceRoom;
  final String checkOutTodayCount;
  final String checkInTodayCount;
  final String totalIncome;
  final String totalOutcome;
  final String totalRestIncome;
  final String netProfit;

  const HotelPdfPrev(
      {super.key,
      required this.roomNumber,
      required this.roomAvailable,
      required this.roomReserved,
      required this.maintenanceRoom,
      required this.checkOutTodayCount,
      required this.checkInTodayCount,
      required this.totalIncome,
      required this.totalOutcome,
      required this.totalRestIncome,
      required this.netProfit,
      required this.hotelName});

  @override
  State<HotelPdfPrev> createState() => _HotelPdfPrevState();
}

class _HotelPdfPrevState extends State<HotelPdfPrev> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        build: (format) => _createHotelPdf(
          format,
          widget.hotelName,
          widget.roomNumber,
          widget.roomAvailable,
          widget.roomReserved,
          widget.maintenanceRoom,
          widget.checkOutTodayCount,
          widget.checkInTodayCount,
          widget.totalIncome,
          widget.totalOutcome,
          widget.totalRestIncome,
          widget.netProfit,
        ),
      ),
    );
  }
}

Future<Uint8List> _createHotelPdf(
  PdfPageFormat format,
  final String hotelName,
  final String roomNumber,
  final String roomAvailable,
  final String roomReserved,
  final String maintenanceRoom,
  final String checkOutTodayCount,
  final String checkInTodayCount,
  final String totalIncome,
  final String totalOutcome,
  final String totalRestIncome,
  final String netProfit,
) async {
  final pdf = pdf_wid.Document(
    version: PdfVersion.pdf_1_4,
    compress: true,
  );
  var arabicFont =
      pdf_wid.Font.ttf(await rootBundle.load("assets/fonts/Amiri-Bold.ttf"));
  pdf.addPage(
    pdf_wid.Page(
      theme: pdf_wid.ThemeData.withFont(base: arabicFont),
      pageFormat: PdfPageFormat.roll80,
      //pageFormat: format,
      build: (context) {
        return pdf_wid.Row(
            mainAxisAlignment: pdf_wid.MainAxisAlignment.end,
            children: [
              pdf_wid.Column(
                  crossAxisAlignment: pdf_wid.CrossAxisAlignment.end,
                  children: [
                    pdf_wid.Text(
                      'اسم الفندق : $hotelName',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'رقم الغرفة : $roomNumber',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'الغرف المتاحة : $roomAvailable',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'الغرف المحجوزة : $roomReserved',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'غرف تحتاج صيانة : $maintenanceRoom',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'عدد غرف دخول اليوم : $checkInTodayCount',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'عدد غرف خروج اليوم : $checkOutTodayCount',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'اجمالي الايرادات : $totalIncome',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'اجمالي المستحقات المتبقية : $totalRestIncome',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'اجمالي المصروفات : $totalOutcome',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'صافي الربح : $netProfit',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                  ]),
            ]);
      },
    ),
  );

  final time = DateTime.now();
  final file =
      File("/storage/emulated/0/Download/hotel_report_${hotelName}.pdf");
  await file.writeAsBytes(await pdf.save());
  return pdf.save();
}

class ServicePdfPrev extends StatefulWidget {
  final String totalNumber;
  final String totalAmount;
  final String totalRest;
  final String serviceName;

  const ServicePdfPrev({
    super.key,
    required this.totalNumber,
    required this.totalAmount,
    required this.totalRest,
    required this.serviceName,
  });

  @override
  State<ServicePdfPrev> createState() => _ServicePdfPrevState();
}

class _ServicePdfPrevState extends State<ServicePdfPrev> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        build: (format) => _createServicePdf(
          format,
          widget.totalNumber,
          widget.totalAmount,
          widget.totalRest,
          widget.serviceName,
        ),
      ),
    );
  }
}

Future<Uint8List> _createServicePdf(
  PdfPageFormat format,
  final String totalNumber,
  final String totalAmount,
  final String totalRest,
  final String serviceName,
) async {
  final pdf = pdf_wid.Document(
    version: PdfVersion.pdf_1_4,
    compress: true,
  );
  var arabicFont =
      pdf_wid.Font.ttf(await rootBundle.load("assets/fonts/Amiri-Bold.ttf"));
  pdf.addPage(
    pdf_wid.Page(
      theme: pdf_wid.ThemeData.withFont(base: arabicFont),
      pageFormat: PdfPageFormat.roll80,
      //pageFormat: format,
      build: (context) {
        return pdf_wid.Row(
            mainAxisAlignment: pdf_wid.MainAxisAlignment.end,
            children: [
              pdf_wid.Column(
                  crossAxisAlignment: pdf_wid.CrossAxisAlignment.end,
                  children: [
                    pdf_wid.Text(
                      'اسم الخدمة : $serviceName',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'عدد الاشخاص المشتركين : $totalNumber',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'اجمالي الايرادات : $totalAmount',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                    pdf_wid.Text(
                      'اجمالي المستحقات المتبقية : $totalRest',
                      textDirection: pdf_wid.TextDirection.rtl,
                    ),
                  ]),
            ]);
      },
    ),
  );

  final time = DateTime.now();
  final file =
      File("/storage/emulated/0/Download/hotel_report_${serviceName}.pdf");
  await file.writeAsBytes(await pdf.save());
  return pdf.save();
}
