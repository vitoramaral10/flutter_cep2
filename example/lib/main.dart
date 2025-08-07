import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cep2/flutter_cep2.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CEP2 Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32), // Brazilian green
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
      ),
      home: const CepDemoPage(),
    );
  }
}

class CepDemoPage extends StatelessWidget {
  const CepDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter CEP2 Demo'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeaderCard(),
            SizedBox(height: 16),
            CepLookupWidget(),
            SizedBox(height: 24),
            _FeaturesList(),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.location_on,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              'Brazilian ZIP Code Lookup',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Powered by ViaCEP API',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CepLookupWidget extends StatefulWidget {
  const CepLookupWidget({super.key});

  @override
  State<CepLookupWidget> createState() => _CepLookupWidgetState();
}

class _CepLookupWidgetState extends State<CepLookupWidget> {
  final _cepService = FlutterCep2();
  final _controller = TextEditingController();

  Cep? _result;
  String? _error;
  bool _isLoading = false;
  CepOutputFormat _selectedFormat = CepOutputFormat.json;

  // Exemplos de CEPs para teste rápido
  final List<String> _exampleCeps = [
    '01310-100', // São Paulo - SP
    '20040-020', // Rio de Janeiro - RJ
    '30112-000', // Belo Horizonte - MG
    '80010-000', // Curitiba - PR
    '60160-230', // Fortaleza - CE
  ];

  @override
  void dispose() {
    _cepService.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _searchCep() async {
    if (_controller.text.trim().isEmpty) {
      setState(() {
        _error = 'Please enter a CEP';
        _result = null;
      });
      return;
    }

    setState(() {
      _result = null;
      _error = null;
      _isLoading = true;
    });

    try {
      final result = await _cepService.search(
        _controller.text,
        output: _selectedFormat,
      );
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } on CepException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Unexpected error: $e';
        _isLoading = false;
      });
    }
  }

  void _useExampleCep(String cep) {
    _controller.text = cep;
    _searchCep();
  }

  void _clearSearch() {
    setState(() {
      _controller.clear();
      _result = null;
      _error = null;
    });
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CEP Lookup',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // CEP Input Field
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter CEP (e.g., 01310-100)',
                hintText: '12345-678 or 12345678',
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                        tooltip: 'Clear',
                      ),
                    IconButton(
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.search),
                      onPressed: _isLoading ? null : _searchCep,
                      tooltip: 'Search',
                    ),
                  ],
                ),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _searchCep(),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            const SizedBox(height: 12),

            // Output Format Selection
            Row(
              children: [
                Text(
                  'Format: ',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                SegmentedButton<CepOutputFormat>(
                  segments: const [
                    ButtonSegment(
                      value: CepOutputFormat.json,
                      label: Text('JSON'),
                      icon: Icon(Icons.code),
                    ),
                    ButtonSegment(
                      value: CepOutputFormat.xml,
                      label: Text('XML'),
                      icon: Icon(Icons.web),
                    ),
                  ],
                  selected: {_selectedFormat},
                  onSelectionChanged: (Set<CepOutputFormat> selection) {
                    setState(() {
                      _selectedFormat = selection.first;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Example CEPs
            Text(
              'Quick examples:',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _exampleCeps
                  .map(
                    (cep) => ActionChip(
                      label: Text(cep),
                      onPressed: () => _useExampleCep(cep),
                      avatar: const Icon(Icons.flash_on, size: 16),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Results
            if (_error != null) _ErrorDisplay(error: _error!),
            if (_result != null)
              _ResultDisplay(result: _result!, onCopy: _copyToClipboard),
          ],
        ),
      ),
    );
  }
}

class _ErrorDisplay extends StatelessWidget {
  const _ErrorDisplay({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultDisplay extends StatelessWidget {
  const _ResultDisplay({required this.result, required this.onCopy});

  final Cep result;
  final Function(String, String) onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: theme.colorScheme.onPrimary),
                const SizedBox(width: 8),
                Text(
                  'Address Found',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.copy, color: theme.colorScheme.onPrimary),
                  onPressed: () => onCopy(result.toString(), 'Full address'),
                  tooltip: 'Copy all data',
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _AddressRow(
                  icon: Icons.pin_drop,
                  label: 'CEP',
                  value: result.cep,
                  onCopy: onCopy,
                ),
                _AddressRow(
                  icon: Icons.location_on,
                  label: 'Street',
                  value: result.logradouro,
                  onCopy: onCopy,
                ),
                if (result.complemento?.isNotEmpty == true)
                  _AddressRow(
                    icon: Icons.info_outline,
                    label: 'Complement',
                    value: result.complemento!,
                    onCopy: onCopy,
                  ),
                _AddressRow(
                  icon: Icons.location_city,
                  label: 'Neighborhood',
                  value: result.bairro,
                  onCopy: onCopy,
                ),
                _AddressRow(
                  icon: Icons.location_city,
                  label: 'City',
                  value: result.localidade,
                  onCopy: onCopy,
                ),
                _AddressRow(
                  icon: Icons.map,
                  label: 'State',
                  value: result.uf,
                  onCopy: onCopy,
                ),
                if (result.ddd?.isNotEmpty == true)
                  _AddressRow(
                    icon: Icons.phone,
                    label: 'Area Code',
                    value: result.ddd!,
                    onCopy: onCopy,
                  ),
                _AddressRow(
                  icon: Icons.tag,
                  label: 'IBGE Code',
                  value: result.ibge,
                  onCopy: onCopy,
                ),
                if (result.gia?.isNotEmpty == true)
                  _AddressRow(
                    icon: Icons.account_balance,
                    label: 'GIA Code',
                    value: result.gia!,
                    onCopy: onCopy,
                  ),
                if (result.siaf?.isNotEmpty == true)
                  _AddressRow(
                    icon: Icons.account_balance,
                    label: 'SIAF Code',
                    value: result.siaf!,
                    onCopy: onCopy,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onCopy,
  });

  final IconData icon;
  final String label;
  final String value;
  final Function(String, String) onCopy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 16),
            onPressed: () => onCopy(value, label),
            tooltip: 'Copy $label',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}

class _FeaturesList extends StatelessWidget {
  const _FeaturesList();

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': Icons.flash_on,
        'title': 'Fast & Reliable',
        'description':
            'Powered by ViaCEP API with comprehensive error handling',
      },
      {
        'icon': Icons.code,
        'title': 'Multiple Formats',
        'description': 'Supports JSON and XML output formats',
      },
      {
        'icon': Icons.phone_android,
        'title': 'Cross Platform',
        'description': 'Works on Android, iOS, Web, Windows, macOS, and Linux',
      },
      {
        'icon': Icons.security,
        'title': 'Null Safety',
        'description': 'Built with modern Dart null safety features',
      },
      {
        'icon': Icons.bug_report,
        'title': 'Well Tested',
        'description': 'Comprehensive test suite with 100% coverage',
      },
      {
        'icon': Icons.integration_instructions,
        'title': 'Easy Integration',
        'description': 'Simple API with excellent documentation',
      },
    ];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.stars, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Plugin Features',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        feature['icon'] as IconData,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        feature['title'] as String,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        feature['description'] as String,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: FilledButton.icon(
                onPressed: () {
                  launchUrl(Uri.parse('https://pub.dev/packages/flutter_cep2'));
                },
                icon: const Icon(Icons.library_books),
                label: const Text('View Documentation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
