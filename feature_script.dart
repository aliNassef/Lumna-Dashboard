import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    // ignore: avoid_print
    print('Please provide a feature name.');
    return;
  }

  final featureName = arguments[0];
  createMVVMFeature(featureName);
}

void createMVVMFeature(String featureName) {
  final featureDir = 'lib/features/$featureName';

  // ===================== Directories =====================
  final presentationDir = '$featureDir/presentation';
  final viewsDir = '$presentationDir/views';
  final widgetsDir = '$presentationDir/widgets';

  final dataDir = '$featureDir/data';
  final modelsDir = '$dataDir/models';
  final datasourceDir = '$dataDir/datasource';
  final repoDir = '$dataDir/repo';

  for (final dir in [
    viewsDir,
    widgetsDir,
    modelsDir,
    datasourceDir,
    repoDir,
  ]) {
    Directory(dir).createSync(recursive: true);
  }

  final className = capitalize(featureName);

  // ===================== View =====================
  File('$viewsDir/${featureName}_view.dart').writeAsStringSync('''
import 'package:flutter/material.dart';
import '../widgets/${featureName}_view_body.dart';

class ${className}View extends StatelessWidget {
  const ${className}View({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: ${className}ViewBody(),
      ),
    );
  }
}
''');

  // ===================== View Body (Widget) =====================
  File('$widgetsDir/${featureName}_view_body.dart').writeAsStringSync('''
import 'package:flutter/material.dart';

class ${className}ViewBody extends StatelessWidget {
  const ${className}ViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('$className View Body'),
    );
  }
}
''');

  // ===================== Model =====================
  File('$modelsDir/${featureName}_model.dart').writeAsStringSync('''
class ${className}Model {
  // TODO: Implement model
}
''');

  // ===================== Data Source =====================
  File(
    '$datasourceDir/${featureName}_remote_datasource.dart',
  ).writeAsStringSync('''
abstract interface class ${className}RemoteDataSource {
  // TODO: Define remote methods
}

class ${className}RemoteDataSourceImpl
    implements ${className}RemoteDataSource {
  // TODO: Implement remote methods
}
''');

  // ===================== Repository =====================
  File('$repoDir/${featureName}_repo.dart').writeAsStringSync('''
abstract interface class ${className}Repo {
  // TODO: Define repo methods
}

class ${className}RepoImpl implements ${className}Repo {
  // TODO: Implement repo methods
}
''');

  // ignore: avoid_print
  print('Feature structure created for $featureName 🚀');
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
