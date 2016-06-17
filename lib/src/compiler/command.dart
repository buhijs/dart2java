// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:analyzer/src/generated/source.dart' show Source;
import 'package:analyzer/src/summary/package_bundle_reader.dart'
    show InSummarySource;
import 'compiler.dart'
    show BuildUnit, CompilerOptions, JavaFile, ModuleCompiler;
import '../analyzer/context.dart' show AnalyzerOptions;
import 'package:path/path.dart' as path;

typedef void MessageHandler(Object message);

/// The command for invoking the modular compiler.
class CompileCommand extends Command {
  get name => 'compile';
  get description => 'Compile a set of Dart files into a JavaScript module.';
  final MessageHandler messageHandler;

  CompileCommand({MessageHandler messageHandler})
      : this.messageHandler = messageHandler ?? print {
    argParser.addOption('out', abbr: 'o', help: 'Output file (required)');
    argParser.addOption('module-root',
        help: 'Root module directory. '
            'Generated module paths are relative to this root.');
    argParser.addOption('build-root',
        help: 'Root of source files. '
            'Generated library names are relative to this root.');
    CompilerOptions.addArguments(argParser);
    AnalyzerOptions.addArguments(argParser);
  }

  @override
  void run() {
    var compiler =
        new ModuleCompiler(new AnalyzerOptions.fromArguments(argResults));
    var compilerOptions = new CompilerOptions.fromArguments(argResults);
    var outPath = argResults['out'];

    if (outPath == null) {
      usageException('Please include the output file location. For example:\n'
          '    -o PATH/TO/OUTPUT_FILE.js');
    }

    var buildRoot = argResults['build-root'] as String;
    if (buildRoot != null) {
      buildRoot = path.absolute(buildRoot);
    } else {
      buildRoot = Directory.current.path;
    }
    var moduleRoot = argResults['module-root'] as String;
    String modulePath;
    if (moduleRoot != null) {
      moduleRoot = path.absolute(moduleRoot);
      if (!path.isWithin(moduleRoot, outPath)) {
        usageException('Output file $outPath must be within the module root '
            'directory $moduleRoot');
      }
      modulePath =
          path.withoutExtension(path.relative(outPath, from: moduleRoot));
    } else {
      moduleRoot = path.dirname(outPath);
      modulePath = path.basenameWithoutExtension(outPath);
    }

    var unit = new BuildUnit(modulePath, buildRoot, argResults.rest,
        (source) => _moduleForLibrary(moduleRoot, source));

    JavaFile module = compiler.compile(unit, compilerOptions);
    module.errors.forEach(messageHandler);

    if (!module.isValid) throw new CompileErrorException();

    new File(outPath).writeAsStringSync(module.code);
  }

  String _moduleForLibrary(String moduleRoot, Source source) {
    if (source is InSummarySource) {
      var summaryPath = source.summaryPath;
      if (path.isWithin(moduleRoot, summaryPath)) {
        return path
            .withoutExtension(path.relative(summaryPath, from: moduleRoot));
      }

      throw usageException(
          'Imported file ${source.uri} is not within the module root '
          'directory $moduleRoot');
    }

    throw usageException(
        'Imported file "${source.uri}" was not found as a summary or source '
        'file. Please pass in either the summary or the source file '
        'for this import.');
  }
}

/// Thrown when the input source code has errors.
class CompileErrorException implements Exception {
  toString() => '\nPlease fix all errors before compiling (warnings are okay).';
}
