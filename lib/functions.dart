import 'package:gsheets/gsheets.dart';

import 'model/results_field.dart';

class Functions {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "gsheets-342509",
  "private_key_id": "e1b0352a625e30eda41129c0b6917f1c899325da",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDwdo81t4NBWAtW\ntOY2OSDm2WuxEV93kJVGslPhN89MXV81BsRn/Zuv3fPqg/+exfKrIl9bUUcu/w3H\noxD7/vviqV5OSJkG3DUhI9RIkcs9wElltlUXMXpOUbfFbPhgjYmA127/8RGCf04c\n4Gq4zR14MWDnBVUHE+DOfTM8myKc2mEk6f1oqctBRJpqDc0CAXSo6XmeYqMSyd4u\nrlFig7iEPUf75KbYk9zkIljzHf5nXkAoWFfYsDBNu+IucLh5FHdQc5QKw5aGsHpf\n3ygngxm4wYij6oFWUy3Xw8VSU/En011K1XSGcJ3BVbOPDRfmaHSBun1tA62Xmgdu\nViW6QoaPAgMBAAECggEAVId45Es0ar4Gjl5dJuaCOGRpxP70blV3BDkf32X9Cz0v\ngLZ2SJAQMIx3eBMawreXDK2yk6lIuq6SK4GZMNx7szwSmLZQhObYDmRH9ZK6vWRg\n6M5lrxeHhQyY61/ZGCfpFE+nB3W40ATscp45JemE2IGTLOLk9u338t50KnPmgPhd\nBIbUKajAbsoWlnLcuftXWfmVH2tyX6isEnbXasTfwBc13iETEOMeFT83whrd/urp\nOpvHtolIuZhEsHTk+A9uMttcJWhNJWiWDHi7WoMvk/WYM9VkU9C3T+geEq5AaxyN\nkoUjLyATofrY6ZOiTjBixIzroIkeLuAxs5y4TzctYQKBgQD8AI8KpprYxDEk42pn\n4RjRxqSwb6b3Xc5fmuT5QkZrdVBl0860q68F7omkWmQdzx639JK2IdIc7vYKsjko\nHLlhfFiMZJhZGFdoK3LX23RzoteMv9OBtL/9xFdP1QSfPupua9E39Y6JFu/5PgP/\n/AoXWkXOq+BNDUPQm0I6L5VwOQKBgQD0RyNE5KEGijRm9pCxA7/5NcbUU/PES/vg\nD+BCN520H4nPAbdkJChj7FCIT7Z51SeM8PoqgB5KGTjv/YtENdCPK1FsZ6W7u+93\nzUWq9TMBqJpDnVrY29t4bkhHO28Q6UbjotNedHHGDuPARJV8FOuQxTp/cf1dprws\nEfesjyYdBwKBgQDoWm+Jh4Jg+czCUXmL3G2xBnJVSC1wCas+Vahn92bMr/d4XCpM\nRbx0QLPiuYF0RsPxI22ex2JfUSnFRP0Uch+vtiJDGIGsLJhzMRSL2QnvkScj3L9c\n6dbYWg+TSTsgxbcMJxdafGx3FJIhgr/XaIG5dH/HBo0jHmb30h/nXHZyaQKBgQCa\ntc9Vm8OMY82qhHDBW9GjIXcLFRynb0RX9VYgOh8sbGkYbUrcJrZaCto6atn0MZb6\nAck/T6NfZLgV7yvcCIVNl67bDI3/55hT9PMxwlgKreD9/9QA0sYecSJf0vmV6VjX\nZVGfWfqQ6O8/33AZhRpotzFEdEp2nNpCwyJs7MDD0wKBgQDb6uFl8rQv5TuKUytO\nwLwWh7nc5IMhUiJogAHD96Ty5o2J8P9yzPR40ydFSjrcbYk0VDlElMLmi2CqdMic\n+4vLXDS8kh5JYEHVvn2pgwKMN3B1DSDKBKhUvLZDaszg+I+mD8YR9opeHOB1jTOT\nNhrCOC4jb8lAaxX7FLwHnLK2tw==\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@gsheets-342509.iam.gserviceaccount.com",
  "client_id": "103321195291265096455",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40gsheets-342509.iam.gserviceaccount.com"
}
''';
  static const _spreadsheetId = '12Xo8irrB5JI1TfFx0g1kPyO_TkXkutfJrshuSjHuVHI';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _dataSheet;
  static Worksheet? _resultsSheet;
  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _dataSheet = await _getWorkSheet(spreadsheet, title: 'Data');
      _resultsSheet = await _getWorkSheet(spreadsheet, title: 'Results');

      final firstRow = ResultsFields.getFields();
      await _resultsSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      // ignore: avoid_print
      print('Init Error $e');
    }
  }

  static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet,
      {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future<List<List<String>>> getDataRows() async {
    return await _dataSheet!.values.allRows();
  }

  static backend() async {
    List<List<String>> rows = (await getDataRows());
    Future.delayed(const Duration(seconds: 2));
    rows.removeAt(0);
    //re.add('Status');
    // print(re);
    for (var list in rows) {
      // print(i);
      // await _resultsSheet!.values.appendRow(i);
      // print(int.parse(list.elementAt(list.length - 1)));
      if (int.parse(list.elementAt(list.length - 1)) >= 40) {
        list.add('Pass');
      } else {
        list.add('Fail');
      }

      await _resultsSheet!.values.appendRow(list);
    }
  }
}
