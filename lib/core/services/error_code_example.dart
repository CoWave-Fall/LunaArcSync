// Example usage of ErrorCodeService
// This file demonstrates how to use the ErrorCodeService in your application
// DO NOT include this file in production builds

import 'package:flutter/material.dart';
import 'error_code_service.dart';

/// Example widget showing error code usage
class ErrorCodeExample extends StatelessWidget {
  const ErrorCodeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Code Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            'Account Module',
            [
              'ACC_ERR_001',
              'ACC_ERR_002',
              'ACC_SUC_001',
              'ACC_ERR_003',
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            'Page Module',
            [
              'PAG_ERR_001',
              'PAG_ERR_002',
              'PAG_ERR_014',
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            'Page Module (with parameters)',
            [],
            customCards: [
              _buildParameterCard(
                context,
                'PAG_ERR_003',
                {'duplicatePageIds': '123, 456, 789'},
              ),
              _buildParameterCard(
                context,
                'PAG_ERR_004',
                {'duplicateOrders': '1, 2, 3'},
              ),
              _buildParameterCard(
                context,
                'PAG_ERR_006',
                {'maxOrder': '10'},
              ),
              _buildParameterCard(
                context,
                'PAG_ERR_013',
                {'pageId': '123', 'documentId': '456'},
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            'Job Module',
            [
              'JOB_SUC_001',
              'JOB_SUC_002',
              'JOB_SUC_003',
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            'PDF Module',
            [
              'PDF_ERR_001',
              'PDF_ERR_002',
              'PDF_ERR_003',
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            'OCR Module',
            [
              'OCR_ERR_001',
              'OCR_ERR_002',
              'OCR_ERR_003',
              'OCR_ERR_004',
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            'Utility Methods',
            [],
            customCards: [
              _buildUtilityCard(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<String> errorCodes, {
    List<Widget>? customCards,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...errorCodes.map((code) => _buildErrorCard(context, code)),
        if (customCards != null) ...customCards,
      ],
    );
  }

  Widget _buildErrorCard(BuildContext context, String errorCode) {
    final message = ErrorCodeService.getMessage(context, errorCode);
    final isError = ErrorCodeService.isError(errorCode);
    final isSuccess = ErrorCodeService.isSuccess(errorCode);

    return Card(
      color: isError
          ? Colors.red.withOpacity(0.1)
          : isSuccess
              ? Colors.green.withOpacity(0.1)
              : null,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          isError
              ? Icons.error
              : isSuccess
                  ? Icons.check_circle
                  : Icons.info,
          color: isError
              ? Colors.red
              : isSuccess
                  ? Colors.green
                  : Colors.blue,
        ),
        title: Text(errorCode),
        subtitle: Text(message),
      ),
    );
  }

  Widget _buildParameterCard(
    BuildContext context,
    String errorCode,
    Map<String, String> params,
  ) {
    final message = ErrorCodeService.getMessage(context, errorCode, params: params);

    return Card(
      color: Colors.orange.withOpacity(0.1),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.code, color: Colors.orange),
        title: Text(errorCode),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Parameters: ${params.toString()}'),
            const SizedBox(height: 4),
            Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildUtilityCard(BuildContext context) {
    const errorCode = 'ACC_ERR_001';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Utility Methods Example',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Error Code: $errorCode'),
            const SizedBox(height: 4),
            Text('Module: ${ErrorCodeService.getModule(errorCode)}'),
            Text('Type: ${ErrorCodeService.getType(errorCode)}'),
            Text('Number: ${ErrorCodeService.getNumber(errorCode)}'),
            const SizedBox(height: 4),
            Text('Is Error: ${ErrorCodeService.isError(errorCode)}'),
            Text('Is Success: ${ErrorCodeService.isSuccess(errorCode)}'),
          ],
        ),
      ),
    );
  }
}

/// Example of using ErrorCodeService in a Cubit/Repository
void exampleApiCall(BuildContext context) async {
  try {
    // Simulated API response
    final response = {
      'success': false,
      'errorCode': 'ACC_ERR_001',
      'data': null,
    };

    if (response['success'] == false && response['errorCode'] != null) {
      final errorCode = response['errorCode'] as String;
      final message = ErrorCodeService.getMessage(context, errorCode);

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } catch (e) {
    // Handle exception
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

/// Example of using ErrorCodeService with parameters
void exampleApiCallWithParams(BuildContext context) async {
  try {
    // Simulated API response with parameters
    final response = {
      'success': false,
      'errorCode': 'PAG_ERR_013',
      'params': {
        'pageId': '12345',
        'documentId': '67890',
      },
    };

    if (response['success'] == false && response['errorCode'] != null) {
      final errorCode = response['errorCode'] as String;
      final params = response['params'] as Map<String, String>?;
      final message = ErrorCodeService.getMessage(
        context,
        errorCode,
        params: params,
      );

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } catch (e) {
    // Handle exception
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

