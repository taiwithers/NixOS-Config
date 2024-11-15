{ colours }:
{
  "autopep8.args" = [
    "--max-line-length=120"
  ];
  "debug.allowBreakpointsEverywhere" = true;
  "breadcrumbs.filePath" = "last";
  "debug.autoExpandLazyVariables" = "on";
  "debug.confirmOnExit" = "always";
  "debug.console.closeOnEnd" = true;
  "debug.hideLauncherWhileDebugging" = true;
  "debug.inlineValues" = "on";
  "debug.onTaskErrors" = "abort";
  "diffEditor.experimental.showMoves" = true;
  "diffEditor.hideUnchangedRegions.enabled" = true;
  "editor.codeActionWidget.showHeaders" = false;
  "editor.copyWithSyntaxHighlighting" = false;
  "editor.cursorSurroundingLines" = 1;
  "editor.cursorWidth" = 2;
  "editor.defaultColorDecorators" = true;
  "editor.dragAndDrop" = false;
  "editor.dropIntoEditor.enabled" = false;
  "editor.find.autoFindInSelection" = "multiline";
  "editor.find.cursorMoveOnType" = false;
  # "editor.fontFamily" = "'Intel One Mono', 'SpaceMono Nerd Font', monospace";
  # "editor.fontSize" = 16;
  "editor.formatOnPaste" = true;
  "editor.formatOnSaveMode" = "modificationsIfAvailable";
  "editor.guides.bracketPairsHorizontal" = false;
  "editor.linkedEditing" = true;
  "editor.minimap.autohide" = true;
  "editor.mouseWheelZoom" = true;
  "editor.renderLineHighlight" = "gutter";
  "editor.stickyScroll.enabled" = true;
  "editor.stickyScroll.maxLineCount" = 3;
  "editor.stickyTabStops" = true;
  "editor.suggest.insertMode" = "replace";
  "editor.suggest.showStatusBar" = true;
  "editor.suggest.snippetsPreventQuickSuggestions" = true;
  "editor.tokenColorCustomizations" = {
    "textMateRules" = with colours.hex-hash; [
      {
        "name" = "unison punctuation";
        "scope" = "punctuation.definition.delayed.unison,punctuation.definition.list.begin.unison,punctuation.definition.list.end.unison,punctuation.definition.ability.begin.unison,punctuation.definition.ability.end.unison,punctuation.operator.assignment.as.unison,punctuation.separator.pipe.unison,punctuation.separator.delimiter.unison,punctuation.definition.hash.unison";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "haskell variable generic-type";
        "scope" = "variable.other.generic-type.haskell";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "haskell storage type";
        "scope" = "storage.type.haskell";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "support.variable.magic.python";
        "scope" = "support.variable.magic.python";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "punctuation.separator.parameters.python";
        "scope" = "punctuation.separator.period.python,punctuation.separator.element.python,punctuation.parenthesis.begin.python,punctuation.parenthesis.end.python";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "variable.parameter.function.language.special.self.python";
        "scope" = "variable.parameter.function.language.special.self.python";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "storage.modifier.lifetime.rust";
        "scope" = "storage.modifier.lifetime.rust";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "support.function.std.rust";
        "scope" = "support.function.std.rust";
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "entity.name.lifetime.rust";
        "scope" = "entity.name.lifetime.rust";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "variable.language.rust";
        "scope" = "variable.language.rust";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "support.constant.edge";
        "scope" = "support.constant.edge";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "regexp constant character-class";
        "scope" = "constant.other.character-class.regexp";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "regexp operator.quantifier";
        "scope" = "keyword.operator.quantifier.regexp";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "punctuation.definition";
        "scope" = "punctuation.definition.string.begin,punctuation.definition.string.end";
        "settings" = {
          "foreground" = "${green}";
        };
      }
      {
        "name" = "Text";
        "scope" = "variable.parameter.function";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "Comment Markup Link";
        "scope" = "comment markup.link";
        "settings" = {
          "foreground" = "${grey}";
        };
      }
      {
        "name" = "markup diff";
        "scope" = "markup.changed.diff";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "diff";
        "scope" = "meta.diff.header.from-file,meta.diff.header.to-file,punctuation.definition.from-file.diff,punctuation.definition.to-file.diff";
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "inserted.diff";
        "scope" = "markup.inserted.diff";
        "settings" = {
          "foreground" = "${green}";
        };
      }
      {
        "name" = "deleted.diff";
        "scope" = "markup.deleted.diff";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "c++ function";
        "scope" = "meta.function.c,meta.function.cpp";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "c++ block";
        "scope" = "punctuation.section.block.begin.bracket.curly.cpp,punctuation.section.block.end.bracket.curly.cpp,punctuation.terminator.statement.c,punctuation.section.block.begin.bracket.curly.c,punctuation.section.block.end.bracket.curly.c,punctuation.section.parens.begin.bracket.round.c,punctuation.section.parens.end.bracket.round.c,punctuation.section.parameters.begin.bracket.round.c,punctuation.section.parameters.end.bracket.round.c";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "js/ts punctuation separator key-value";
        "scope" = "punctuation.separator.key-value";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "js/ts import keyword";
        "scope" = "keyword.operator.expression.import";
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "math js/ts";
        "scope" = "support.constant.math";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "math property js/ts";
        "scope" = "support.constant.property.math";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "js/ts variable.other.constant";
        "scope" = "variable.other.constant";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "java type";
        "scope" = [
          "storage.type.annotation.java"
          "storage.type.object.array.java"
        ];
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "java source";
        "scope" = "source.java";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "java modifier.import";
        "scope" = "punctuation.section.block.begin.java,punctuation.section.block.end.java,punctuation.definition.method-parameters.begin.java,punctuation.definition.method-parameters.end.java,meta.method.identifier.java,punctuation.section.method.begin.java,punctuation.section.method.end.java,punctuation.terminator.java,punctuation.section.class.begin.java,punctuation.section.class.end.java,punctuation.section.inner-class.begin.java,punctuation.section.inner-class.end.java,meta.method-call.java,punctuation.section.class.begin.bracket.curly.java,punctuation.section.class.end.bracket.curly.java,punctuation.section.method.begin.bracket.curly.java,punctuation.section.method.end.bracket.curly.java,punctuation.separator.period.java,punctuation.bracket.angle.java,punctuation.definition.annotation.java,meta.method.body.java";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "java modifier.import";
        "scope" = "meta.method.java";
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "java modifier.import";
        "scope" = "storage.modifier.import.java,storage.type.java,storage.type.generic.java";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "java instanceof";
        "scope" = "keyword.operator.instanceof.java";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "java variable.name";
        "scope" = "meta.definition.variable.name.java";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "operator logical";
        "scope" = "keyword.operator.logical";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "operator bitwise";
        "scope" = "keyword.operator.bitwise";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "operator channel";
        "scope" = "keyword.operator.channel";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "support.constant.property-value.scss";
        "scope" = "support.constant.property-value.scss,support.constant.property-value.css";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "CSS/SCSS/LESS Operators";
        "scope" = "keyword.operator.css,keyword.operator.scss,keyword.operator.less";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "css color standard name";
        "scope" = "support.constant.color.w3c-standard-color-name.css,support.constant.color.w3c-standard-color-name.scss";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "css comma";
        "scope" = "punctuation.separator.list.comma.css";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "css attribute-name.id";
        "scope" = "support.constant.color.w3c-standard-color-name.css";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "css property-name";
        "scope" = "support.type.vendored.property-name.css";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "js/ts module";
        "scope" = "support.module.node,support.type.object.module,support.module.node";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "entity.name.type.module";
        "scope" = "entity.name.type.module";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "js variable readwrite";
        "scope" = "variable.other.readwrite,meta.object-literal.key,support.variable.property,support.variable.object.process,support.variable.object.node";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "js/ts json";
        "scope" = "support.constant.json";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "js/ts Keyword";
        "scope" = [
          "keyword.operator.expression.instanceof"
          "keyword.operator.new"
          "keyword.operator.ternary"
          "keyword.operator.optional"
          "keyword.operator.expression.keyof"
        ];
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "js/ts console";
        "scope" = "support.type.object.console";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "js/ts support.variable.property.process";
        "scope" = "support.variable.property.process";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "js console function";
        "scope" = "entity.name.function,support.function.console";
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "keyword.operator.misc.rust";
        "scope" = "keyword.operator.misc.rust";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "keyword.operator.sigil.rust";
        "scope" = "keyword.operator.sigil.rust";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "operator";
        "scope" = "keyword.operator.delete";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "js dom";
        "scope" = "support.type.object.dom";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "js dom variable";
        "scope" = "support.variable.dom,support.variable.property.dom";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "keyword.operator";
        "scope" = "keyword.operator.arithmetic,keyword.operator.comparison,keyword.operator.decrement,keyword.operator.increment,keyword.operator.relational";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "C operator assignment";
        "scope" = "keyword.operator.assignment.c,keyword.operator.comparison.c,keyword.operator.c,keyword.operator.increment.c,keyword.operator.decrement.c,keyword.operator.bitwise.shift.c,keyword.operator.assignment.cpp,keyword.operator.comparison.cpp,keyword.operator.cpp,keyword.operator.increment.cpp,keyword.operator.decrement.cpp,keyword.operator.bitwise.shift.cpp";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "Punctuation";
        "scope" = "punctuation.separator.delimiter";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "Other punctuation .c";
        "scope" = "punctuation.separator.c,punctuation.separator.cpp";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "C type posix-reserved";
        "scope" = "support.type.posix-reserved.c,support.type.posix-reserved.cpp";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "keyword.operator.sizeof.c";
        "scope" = "keyword.operator.sizeof.c,keyword.operator.sizeof.cpp";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "python parameter";
        "scope" = "variable.parameter.function.language.python";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "python type";
        "scope" = "support.type.python";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "python logical";
        "scope" = "keyword.operator.logical.python";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "pyCs";
        "scope" = "variable.parameter.function.python";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "python block";
        "scope" = "punctuation.definition.arguments.begin.python,punctuation.definition.arguments.end.python,punctuation.separator.arguments.python,punctuation.definition.list.begin.python,punctuation.definition.list.end.python";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "python function-call.generic";
        "scope" = "meta.function-call.generic.python";
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "python placeholder reset to normal string";
        "scope" = "constant.character.format.placeholder.other.python";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "Operators";
        "scope" = "keyword.operator";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "Compound Assignment Operators";
        "scope" = "keyword.operator.assignment.compound";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "Compound Assignment Operators js/ts";
        "scope" = "keyword.operator.assignment.compound.js,keyword.operator.assignment.compound.ts";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "Keywords";
        "scope" = "keyword";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "Namespaces";
        "scope" = "entity.name.namespace";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "Variables";
        "scope" = "variable";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "Variables";
        "scope" = "variable.c";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "Language variables";
        "scope" = "variable.language";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "Java Variables";
        "scope" = "token.variable.parameter.java";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "Java Imports";
        "scope" = "import.storage.java";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "Packages";
        "scope" = "token.package.keyword";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "Packages";
        "scope" = "token.package";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "Functions";
        "scope" = [
          "entity.name.function"
          "meta.require"
          "support.function.any-method"
          "variable.function"
        ];
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "Classes";
        "scope" = "entity.name.type.namespace";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "Classes";
        "scope" = "support.class, entity.name.type.class";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "Class name";
        "scope" = "entity.name.class.identifier.namespace.type";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "Class name";
        "scope" = [
          "entity.name.class"
          "variable.other.class.js"
          "variable.other.class.ts"
        ];
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "Class name php";
        "scope" = "variable.other.class.php";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "Type Name";
        "scope" = "entity.name.type";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "Keyword Control";
        "scope" = "keyword.control";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "Control Elements";
        "scope" = "control.elements, keyword.operator.less";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "Methods";
        "scope" = "keyword.other.special-method";
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "Storage";
        "scope" = "storage";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "Storage JS TS";
        "scope" = "token.storage";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "Source Js Keyword Operator Delete,source Js Keyword Operator In,source Js Keyword Operator Of,source Js Keyword Operator Instanceof,source Js Keyword Operator New,source Js Keyword Operator Typeof,source Js Keyword Operator Void";
        "scope" = "keyword.operator.expression.delete,keyword.operator.expression.in,keyword.operator.expression.of,keyword.operator.expression.instanceof,keyword.operator.new,keyword.operator.expression.typeof,keyword.operator.expression.void";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "Java Storage";
        "scope" = "token.storage.type.java";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "Support";
        "scope" = "support.function";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "Support type";
        "scope" = "support.type.property-name";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "Support type";
        "scope" = "support.constant.property-value";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "Support type";
        "scope" = "support.constant.font-name";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "Meta tag";
        "scope" = "meta.tag";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "Strings";
        "scope" = "string";
        "settings" = {
          "foreground" = "${green}";
        };
      }
      {
        "name" = "Inherited Class";
        "scope" = "entity.other.inherited-class";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "Constant other symbol";
        "scope" = "constant.other.symbol";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "Integers";
        "scope" = "constant.numeric";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "Constants";
        "scope" = "constant";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "Constants";
        "scope" = "punctuation.definition.constant";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "Tags";
        "scope" = "entity.name.tag";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "Attributes";
        "scope" = "entity.other.attribute-name";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "Attribute IDs";
        "scope" = "entity.other.attribute-name.id";
        "settings" = {
          "fontStyle" = "normal";
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "Attribute class";
        "scope" = "entity.other.attribute-name.class.css";
        "settings" = {
          "fontStyle" = "normal";
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "Selector";
        "scope" = "meta.selector";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "Headings";
        "scope" = "markup.heading";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "Headings";
        "scope" = "markup.heading punctuation.definition.heading, entity.name.section";
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "Units";
        "scope" = "keyword.other.unit";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "Bold";
        "scope" = "markup.bold,todo.bold";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "Bold";
        "scope" = "punctuation.definition.bold";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "markup Italic";
        "scope" = "markup.italic, punctuation.definition.italic,todo.emphasis";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "emphasis md";
        "scope" = "emphasis md";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "[VSCODE-CUSTOM] Markdown headings";
        "scope" = "entity.name.section.markdown";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "[VSCODE-CUSTOM] Markdown heading Punctuation Definition";
        "scope" = "punctuation.definition.heading.markdown";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "punctuation.definition.list.begin.markdown";
        "scope" = "punctuation.definition.list.begin.markdown";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "[VSCODE-CUSTOM] Markdown heading setext";
        "scope" = "markup.heading.setext";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "[VSCODE-CUSTOM] Markdown Punctuation Definition Bold";
        "scope" = "punctuation.definition.bold.markdown";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "[VSCODE-CUSTOM] Markdown Inline Raw";
        "scope" = "markup.inline.raw.markdown";
        "settings" = {
          "foreground" = "${green}";
        };
      }
      {
        "name" = "[VSCODE-CUSTOM] Markdown Inline Raw";
        "scope" = "markup.inline.raw.string.markdown";
        "settings" = {
          "foreground" = "${green}";
        };
      }
      {
        "name" = "[VSCODE-CUSTOM] Markdown List Punctuation Definition";
        "scope" = "punctuation.definition.list.markdown";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "[VSCODE-CUSTOM] Markdown Punctuation Definition String";
        "scope" = [
          "punctuation.definition.string.begin.markdown"
          "punctuation.definition.string.end.markdown"
          "punctuation.definition.metadata.markdown"
        ];
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "beginning.punctuation.definition.list.markdown";
        "scope" = [
          "beginning.punctuation.definition.list.markdown"
        ];
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "[VSCODE-CUSTOM] Markdown Punctuation Definition Link";
        "scope" = "punctuation.definition.metadata.markdown";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "[VSCODE-CUSTOM] Markdown Underline Link/Image";
        "scope" = "markup.underline.link.markdown,markup.underline.link.image.markdown";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "[VSCODE-CUSTOM] Markdown Link Title/Description";
        "scope" = "string.other.link.title.markdown,string.other.link.description.markdown";
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "Regular Expressions";
        "scope" = "string.regexp";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "Escape Characters";
        "scope" = "constant.character.escape";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "Embedded";
        "scope" = "punctuation.section.embedded, variable.interpolation";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "Embedded";
        "scope" = "punctuation.section.embedded.begin,punctuation.section.embedded.end";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "illegal";
        "scope" = "invalid.illegal";
        "settings" = {
          "foreground" = "${white}";
        };
      }
      {
        "name" = "illegal";
        "scope" = "invalid.illegal.bad-ampersand.html";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "Broken";
        "scope" = "invalid.broken";
        "settings" = {
          "foreground" = "${white}";
        };
      }
      {
        "name" = "Deprecated";
        "scope" = "invalid.deprecated";
        "settings" = {
          "foreground" = "${white}";
        };
      }
      {
        "name" = "Unimplemented";
        "scope" = "invalid.unimplemented";
        "settings" = {
          "foreground" = "${white}";
        };
      }
      {
        "name" = "Source Json Meta Structure Dictionary Json > String Quoted Json";
        "scope" = "source.json meta.structure.dictionary.json > string.quoted.json";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "Source Json Meta Structure Dictionary Json > String Quoted Json > Punctuation String";
        "scope" = "source.json meta.structure.dictionary.json > string.quoted.json > punctuation.string";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "Source Json Meta Structure Dictionary Json > Value Json > String Quoted Json,source Json Meta Structure Array Json > Value Json > String Quoted Json,source Json Meta Structure Dictionary Json > Value Json > String Quoted Json > Punctuation,source Json Meta Structure Array Json > Value Json > String Quoted Json > Punctuation";
        "scope" = "source.json meta.structure.dictionary.json > value.json > string.quoted.json,source.json meta.structure.array.json > value.json > string.quoted.json,source.json meta.structure.dictionary.json > value.json > string.quoted.json > punctuation,source.json meta.structure.array.json > value.json > string.quoted.json > punctuation";
        "settings" = {
          "foreground" = "${green}";
        };
      }
      {
        "name" = "Source Json Meta Structure Dictionary Json > Constant Language Json,source Json Meta Structure Array Json > Constant Language Json";
        "scope" = "source.json meta.structure.dictionary.json > constant.language.json,source.json meta.structure.array.json > constant.language.json";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "[VSCODE-CUSTOM] JSON Property Name";
        "scope" = "support.type.property-name.json";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "[VSCODE-CUSTOM] JSON Punctuation for Property Name";
        "scope" = "support.type.property-name.json punctuation";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "laravel blade tag";
        "scope" = "text.html.laravel-blade source.php.embedded.line.html entity.name.tag.laravel-blade";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "laravel blade @";
        "scope" = "text.html.laravel-blade source.php.embedded.line.html support.constant.laravel-blade";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "use statement for other classes";
        "scope" = "support.other.namespace.use.php,support.other.namespace.use-as.php,support.other.namespace.php,entity.other.alias.php,meta.interface.php";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "error suppression";
        "scope" = "keyword.operator.error-control.php";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "php instanceof";
        "scope" = "keyword.operator.type.php";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "style double quoted array index normal begin";
        "scope" = "punctuation.section.array.begin.php";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "style double quoted array index normal end";
        "scope" = "punctuation.section.array.end.php";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "php illegal.non-null-typehinted";
        "scope" = "invalid.illegal.non-null-typehinted.php";
        "settings" = {
          "foreground" = "${red}";
        };
      }
      {
        "name" = "php types";
        "scope" = "storage.type.php,meta.other.type.phpdoc.php,keyword.other.type.php,keyword.other.array.phpdoc.php";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "php call-function";
        "scope" = "meta.function-call.php,meta.function-call.object.php,meta.function-call.static.php";
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "php function-resets";
        "scope" = "punctuation.definition.parameters.begin.bracket.round.php,punctuation.definition.parameters.end.bracket.round.php,punctuation.separator.delimiter.php,punctuation.section.scope.begin.php,punctuation.section.scope.end.php,punctuation.terminator.expression.php,punctuation.definition.arguments.begin.bracket.round.php,punctuation.definition.arguments.end.bracket.round.php,punctuation.definition.storage-type.begin.bracket.round.php,punctuation.definition.storage-type.end.bracket.round.php,punctuation.definition.array.begin.bracket.round.php,punctuation.definition.array.end.bracket.round.php,punctuation.definition.begin.bracket.round.php,punctuation.definition.end.bracket.round.php,punctuation.definition.begin.bracket.curly.php,punctuation.definition.end.bracket.curly.php,punctuation.definition.section.switch-block.end.bracket.curly.php,punctuation.definition.section.switch-block.start.bracket.curly.php,punctuation.definition.section.switch-block.begin.bracket.curly.php,punctuation.definition.section.switch-block.end.bracket.curly.php";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "support php constants";
        "scope" = "support.constant.core.rust";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "support php constants";
        "scope" = "support.constant.ext.php,support.constant.std.php,support.constant.core.php,support.constant.parser-token.php";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "php goto";
        "scope" = "entity.name.goto-label.php,support.other.php";
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "php logical/bitwise operator";
        "scope" = "keyword.operator.logical.php,keyword.operator.bitwise.php,keyword.operator.arithmetic.php";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "php regexp operator";
        "scope" = "keyword.operator.regexp.php";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "php comparison";
        "scope" = "keyword.operator.comparison.php";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "php heredoc/nowdoc";
        "scope" = "keyword.operator.heredoc.php,keyword.operator.nowdoc.php";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "python function decorator @";
        "scope" = "meta.function.decorator.python";
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "python function support";
        "scope" = "support.token.decorator.python,meta.function.decorator.identifier.python";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "parameter function js/ts";
        "scope" = "function.parameter";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "brace function";
        "scope" = "function.brace";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "parameter function ruby cs";
        "scope" = "function.parameter.ruby, function.parameter.cs";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "constant.language.symbol.ruby";
        "scope" = "constant.language.symbol.ruby";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "rgb-value";
        "scope" = "rgb-value";
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "rgb value";
        "scope" = "inline-color-decoration rgb-value";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "rgb value less";
        "scope" = "less rgb-value";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "sass selector";
        "scope" = "selector.sass";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "ts primitive/builtin types";
        "scope" = "support.type.primitive.ts,support.type.builtin.ts,support.type.primitive.tsx,support.type.builtin.tsx";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "block scope";
        "scope" = "block.scope.end,block.scope.begin";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "cs storage type";
        "scope" = "storage.type.cs";
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "cs local variable";
        "scope" = "entity.name.variable.local.cs";
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "scope" = "token.info-token";
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "scope" = "token.warn-token";
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "scope" = "token.error-token";
        "settings" = {
          "foreground" = "${red}";
        };
      }
      {
        "scope" = "token.debug-token";
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "String interpolation";
        "scope" = [
          "punctuation.definition.template-expression.begin"
          "punctuation.definition.template-expression.end"
          "punctuation.section.embedded"
        ];
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "Reset JavaScript string interpolation expression";
        "scope" = [
          "meta.template.expression"
        ];
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "Import module JS";
        "scope" = [
          "keyword.operator.module"
        ];
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "js Flowtype";
        "scope" = [
          "support.type.type.flowtype"
        ];
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "js Flow";
        "scope" = [
          "support.type.primitive"
        ];
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "js class prop";
        "scope" = [
          "meta.property.object"
        ];
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "js func parameter";
        "scope" = [
          "variable.parameter.function.js"
        ];
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "js template literals begin";
        "scope" = [
          "keyword.other.template.begin"
        ];
        "settings" = {
          "foreground" = "${green}";
        };
      }
      {
        "name" = "js template literals end";
        "scope" = [
          "keyword.other.template.end"
        ];
        "settings" = {
          "foreground" = "${green}";
        };
      }
      {
        "name" = "js template literals variable braces begin";
        "scope" = [
          "keyword.other.substitution.begin"
        ];
        "settings" = {
          "foreground" = "${green}";
        };
      }
      {
        "name" = "js template literals variable braces end";
        "scope" = [
          "keyword.other.substitution.end"
        ];
        "settings" = {
          "foreground" = "${green}";
        };
      }
      {
        "name" = "js operator.assignment";
        "scope" = [
          "keyword.operator.assignment"
        ];
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "go operator";
        "scope" = [
          "keyword.operator.assignment.go"
        ];
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "go operator";
        "scope" = [
          "keyword.operator.arithmetic.go"
          "keyword.operator.address.go"
        ];
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "Go package name";
        "scope" = [
          "entity.name.package.go"
        ];
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "elm prelude";
        "scope" = [
          "support.type.prelude.elm"
        ];
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "elm constant";
        "scope" = [
          "support.constant.elm"
        ];
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "template literal";
        "scope" = [
          "punctuation.quasi.element"
        ];
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "html/pug (jade) escaped characters and entities";
        "scope" = [
          "constant.character.entity"
        ];
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "styling css pseudo-elements/classes to be able to differentiate from classes which are the same colour";
        "scope" = [
          "entity.other.attribute-name.pseudo-element"
          "entity.other.attribute-name.pseudo-class"
        ];
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "Clojure globals";
        "scope" = [
          "entity.global.clojure"
        ];
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "Clojure symbols";
        "scope" = [
          "meta.symbol.clojure"
        ];
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "Clojure constants";
        "scope" = [
          "constant.keyword.clojure"
        ];
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "CoffeeScript Function Argument";
        "scope" = [
          "meta.arguments.coffee"
          "variable.parameter.function.coffee"
        ];
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "Ini Default Text";
        "scope" = [
          "source.ini"
        ];
        "settings" = {
          "foreground" = "${green}";
        };
      }
      {
        "name" = "Makefile prerequisities";
        "scope" = [
          "meta.scope.prerequisites.makefile"
        ];
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "Makefile text colour";
        "scope" = [
          "source.makefile"
        ];
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "Groovy import names";
        "scope" = [
          "storage.modifier.import.groovy"
        ];
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "Groovy Methods";
        "scope" = [
          "meta.method.groovy"
        ];
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "Groovy Variables";
        "scope" = [
          "meta.definition.variable.name.groovy"
        ];
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "Groovy Inheritance";
        "scope" = [
          "meta.definition.class.inherited.classes.groovy"
        ];
        "settings" = {
          "foreground" = "${green}";
        };
      }
      {
        "name" = "HLSL Semantic";
        "scope" = [
          "support.variable.semantic.hlsl"
        ];
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "HLSL Types";
        "scope" = [
          "support.type.texture.hlsl"
          "support.type.sampler.hlsl"
          "support.type.object.hlsl"
          "support.type.object.rw.hlsl"
          "support.type.fx.hlsl"
          "support.type.object.hlsl"
        ];
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "SQL Variables";
        "scope" = [
          "text.variable"
          "text.bracketed"
        ];
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "types";
        "scope" = [
          "support.type.swift"
          "support.type.vb.asp"
        ];
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "heading 1, keyword";
        "scope" = [
          "entity.name.function.xi"
        ];
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "heading 2, callable";
        "scope" = [
          "entity.name.class.xi"
        ];
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "heading 3, property";
        "scope" = [
          "constant.character.character-class.regexp.xi"
        ];
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "heading 4, type, class, interface";
        "scope" = [
          "constant.regexp.xi"
        ];
        "settings" = {
          "foreground" = "${pink}";
        };
      }
      {
        "name" = "heading 5, enums, preprocessor, constant, decorator";
        "scope" = [
          "keyword.control.xi"
        ];
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "heading 6, number";
        "scope" = [
          "invalid.xi"
        ];
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "string";
        "scope" = [
          "beginning.punctuation.definition.quote.markdown.xi"
        ];
        "settings" = {
          "foreground" = "${green}";
        };
      }
      {
        "name" = "comments";
        "scope" = [
          "beginning.punctuation.definition.list.markdown.xi"
        ];
        "settings" = {
          "foreground" = "${grey}";
        };
      }
      {
        "name" = "link";
        "scope" = [
          "constant.character.xi"
        ];
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "accent";
        "scope" = [
          "accent.xi"
        ];
        "settings" = {
          "foreground" = "${light-blue}";
        };
      }
      {
        "name" = "wikiword";
        "scope" = [
          "wikiword.xi"
        ];
        "settings" = {
          "foreground" = "${peach}";
        };
      }
      {
        "name" = "language operators like '+', '-' etc";
        "scope" = [
          "constant.other.color.rgb-value.xi"
        ];
        "settings" = {
          "foreground" = "${white}";
        };
      }
      {
        "name" = "elements to dim";
        "scope" = [
          "punctuation.definition.tag.xi"
        ];
        "settings" = {
          "foreground" = "${grey}";
        };
      }
      {
        "name" = "C++/C#";
        "scope" = [
          "entity.name.label.cs"
          "entity.name.scope-resolution.function.call"
          "entity.name.scope-resolution.function.definition"
        ];
        "settings" = {
          "foreground" = "${yellow}";
        };
      }
      {
        "name" = "Markdown underscore-style headers";
        "scope" = [
          "entity.name.label.cs"
          "markup.heading.setext.1.markdown"
          "markup.heading.setext.2.markdown"
        ];
        "settings" = {
          "foreground" = "${salmon}";
        };
      }
      {
        "name" = "meta.brace.square";
        "scope" = [
          " meta.brace.square"
        ];
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "name" = "Comments";
        "scope" = "comment, punctuation.definition.comment";
        "settings" = {
          "fontStyle" = "italic";
          "foreground" = "${grey}";
        };
      }
      {
        "name" = "[VSCODE-CUSTOM] Markdown Quote";
        "scope" = "markup.quote.markdown";
        "settings" = {
          "foreground" = "${grey}";
        };
      }
      {
        "name" = "punctuation.definition.block.sequence.item.yaml";
        "scope" = "punctuation.definition.block.sequence.item.yaml";
        "settings" = {
          "foreground" = "${ivory}";
        };
      }
      {
        "scope" = [
          "constant.language.symbol.elixir"
        ];
        "settings" = {
          "foreground" = "${cyan}";
        };
      }
      {
        "name" = "js/ts italic";
        "scope" = "entity.other.attribute-name.js,entity.other.attribute-name.ts,entity.other.attribute-name.jsx,entity.other.attribute-name.tsx,variable.parameter,variable.language.super";
        "settings" = {
          "fontStyle" = "italic";
        };
      }
      {
        "name" = "comment";
        "scope" = "comment.line.double-slash,comment.block.documentation";
        "settings" = {
          "fontStyle" = "italic";
        };
      }
      {
        "name" = "Python Keyword Control";
        "scope" = "keyword.control.import.python,keyword.control.flow.python";
        "settings" = {
          "fontStyle" = "italic";
        };
      }
      {
        "name" = "markup.italic.markdown";
        "scope" = "markup.italic.markdown";
        "settings" = {
          "fontStyle" = "italic";
        };
      }
    ];
  };
  "editor.wordSeparators" = "`~!@#$%^&*()-=+[{]}\\|;:'\",.<>/?_";
  "editor.wordWrapColumn" = 120;
  "editor.wrappingIndent" = "indent";
  "ego.power-tools" = {
    "buttons" = [
      {
        "action" = {
          "command" = "workbench.action.openSettings";
          "type" = "command";
        };
        "text" = "$(gear) Settings";
        "tooltip" = "Open Settings";
      }
    ];
  };
  "explorer.autoReveal" = false;
  "explorer.compactFolders" = false;
  "explorer.confirmDelete" = false;
  "explorer.confirmDragAndDrop" = false;
  "explorer.confirmUndo" = "light";
  "explorer.fileNesting.enabled" = true;
  "files.exclude" = {
    "**/*.aux" = true;
    "**/*.fdb_latexmk" = true;
    "**/*.fls" = true;
    "**/*.synctex.gz" = true;
    "**/.ipynb_checkpoints/**" = true;
    "**/__pycache__/**" = true;
  };
  "files.simpleDialog.enable" = true;
  "files.trimFinalNewlines" = true;
  "files.trimTrailingWhitespace" = true;
  "fortran.fortls.configure" = ".fortlsrc";
  "fortran.fortls.notifyInit" = true;
  "fortran.fortls.path" = "/home/tai/opt/miniforge3/envs/phys913/bin/fortls";
  "git.autofetch" = true;
  "git.closeDiffOnOperation" = true;
  "git.confirmSync" = false;
  "git.enableCommitSigning" = true;
  "git.mergeEditor" = true;
  "git.smartCommitChanges" = "tracked";
  "git.terminalGitEditor" = true;
  "git.timeline.showAuthor" = false;
  "github.gitProtocol" = "ssh";
  "isort.check" = true;
  "isort.showNotifications" = "onError";
  "jupyter.allowUnauthorizedRemoteConnection" = true;
  "jupyter.askForKernelRestart" = false;
  "latex-workshop.latex.tools" = [
    {
      "args" = [
        "-synctex=1"
        "-interaction=nonstopmode"
        "-file-line-error"
        "-pdf"
        "-outdir=%OUTDIR%"
        "%DOC%"
      ];
      "command" = "latexmk";
      "env" = { };
      "name" = "latexmk";
    }
    {
      "args" = [
        "-synctex=1"
        "-interaction=nonstopmode"
        "-file-line-error"
        "%DOC%"
      ];
      "command" = "pdflatex";
      "env" = { };
      "name" = "pdflatex";
    }
    {
      "args" = [
        "%DOCFILE%"
      ];
      "command" = "bibtex";
      "env" = { };
      "name" = "bibtex";
    }
  ];
  "latex-workshop.message.badbox.show" = false;
  "latex-workshop.message.error.show" = false;
  "markdownlint.run" = "onSave";
  "merge-conflict.autoNavigateNextConflict.enabled" = true;
  "notebook.cellToolbarVisibility" = "hover";
  "notebook.diff.ignoreMetadata" = true;
  "notebook.diff.ignoreOutputs" = true;
  "notebook.experimental.remoteSave" = true;
  "notebook.formatOnSave.enabled" = true;
  "notebook.lineNumbers" = "on";
  "notebook.navigation.allowNavigateToSurroundingCells" = false;
  "notebook.output.scrolling" = true;
  "notebook.scrolling.revealNextCellOnExecute" = "none";
  "notebook.stickyScroll.enabled" = true;
  "outline.collapseItems" = "alwaysCollapse";
  "outline.showArrays" = false;
  "outline.showBooleans" = false;
  "outline.showConstants" = false;
  "outline.showEnumMembers" = false;
  "outline.showEnums" = false;
  "outline.showEvents" = false;
  "outline.showFields" = false;
  "outline.showKeys" = false;
  "outline.showModules" = false;
  "outline.showNull" = false;
  "outline.showNumbers" = false;
  "outline.showObjects" = false;
  "outline.showOperators" = false;
  "outline.showStrings" = false;
  "outline.showStructs" = false;
  "outline.showTypeParameters" = false;
  "outline.showVariables" = false;
  "peacock.affectActivityBar" = false;
  "peacock.affectPanelBorder" = true;
  "peacock.affectSashHover" = false;
  "peacock.affectSideBarBorder" = true;
  "peacock.affectStatusBar" = false;
  "peacock.affectTabActiveBorder" = true;
  "problems.showCurrentInStatus" = true;
  "pylint.args" = [
    "--disable=anomalous-backslash-in-string"
    "--disable=bare-except"
    "--disable=broad-exception-caught"
    "--disable=comparison-with-callable"
    "--disable=dangerous-default-value"
    "--disable=fixme"
    "--disable=invalid-name"
    "--disable=logging-fstring-interpolation"
    "--disable=multiple-statements"
    "--disable=no-member"
    "--disable=no-name-in-module"
    "--disable=pointless-string-statement"
    "--disable=redefined-outer-name"
    "--disable=unbalanced-tuple-unpacking"
    "--disable=unspecified-encoding"
    "--disable=unused-import"
    "--disable=unused-variable"
    "--max-line-length=120"
  ];
  "pylint.severity" = {
    "convention" = "Hint";
    "info" = "Hint";
  };
  "pylint.showNotifications" = "onError";
  "python.globalModuleInstallation" = true;
  "python.terminal.activateEnvInCurrentTerminal" = true;
  "rainbow_csv.autodetect_separators" = [
    "TAB"
    ","
    ";"
    "|"
    " "
  ];
  "rainbow_csv.comment_prefix" = "#";
  "rainbow_csv.enable_context_menu_head" = true;
  "rainbow_csv.enable_cursor_position_info" = false;
  "rainbow_csv.rbql_with_headers_by_default" = true;
  "remote.autoForwardPortsSource" = "hybrid";
  "remote.downloadExtensionsLocally" = true;
  "remote.SSH.configFile" = "/home/tai/.ssh/codium-config";
  "scm.alwaysShowActions" = true;
  "scm.alwaysShowRepositories" = true;
  "scm.defaultViewMode" = "tree";
  "scm.diffDecorationsGutterAction" = "none";
  "scm.diffDecorationsGutterPattern" = {
    "added" = true;
  };
  "scm.diffDecorationsGutterVisibility" = "hover";
  "scm.diffDecorationsIgnoreTrimWhitespace" = "true";
  "search.defaultViewMode" = "tree";
  "search.showLineNumbers" = true;
  "search.smartCase" = true;
  "terminal.integrated.cursorStyle" = "line";
  "terminal.integrated.cursorStyleInactive" = "line";
  "terminal.integrated.focusAfterRun" = "terminal";
  "terminal.integrated.hideOnStartup" = false;
  "terminal.integrated.inheritEnv" = "always";
  "todo-tree.filtering.useBuiltInExcludes" = "file and search excludes";
  "todo-tree.general.showIconsInsteadOfTagsInStatusBar" = true;
  "todo-tree.general.statusBar" = "current file";
  "todo-tree.tree.showCountsInTree" = true;
  "vim.autoindent" = false;
  "vim.enableNeovim" = true;
  "vim.foldfix" = true;
  "vim.startInInsertMode" = true;
  "vsicons.dontShowNewVersionMessage" = true;
  "window.commandCenter" = false;
  "window.confirmSaveUntitledWorkspace" = false;
  "window.zoomLevel" = 1;
  "workbench.accounts.experimental.showEntitlements" = true;
  # "workbench.colorCustomizations" = with colours.hex-hash; {
  #   "foreground" = "${ivory}";
  #   "focusBorder" = "${green}";
  #   "selection.background" = "${blue-grey}";
  #   "scrollbar.shadow" = "${black}";
  #   "activityBar.foreground" = "${ivory}";
  #   "activityBar.background" = "${navy}";
  #   "activityBar.inactiveForeground" = "${blue-grey}";
  #   "activityBarBadge.foreground" = "${ivory}";
  #   "activityBarBadge.background" = "${indigo}";
  #   "activityBar.border" = "${blue-grey}";
  #   "sideBar.background" = "${navy}";
  #   "sideBar.foreground" = "${ivory}";
  #   "sideBarSectionHeader.background" = "${black}00";
  #   "sideBarSectionHeader.foreground" = "${light-grey}";
  #   "sideBarSectionHeader.border" = "${blue-grey}";
  #   "sideBarTitle.foreground" = "${light-grey}";
  #   "sideBar.border" = "${blue-grey}";
  #   "list.inactiveSelectionBackground" = "${dark-blue}";
  #   "list.inactiveSelectionForeground" = "${light-grey}";
  #   "list.hoverBackground" = "${dark-blue}";
  #   "list.hoverForeground" = "${light-grey}";
  #   "list.activeSelectionBackground" = "${indigo}";
  #   "list.activeSelectionForeground" = "${ivory}";
  #   "tree.indentGuidesStroke" = "#585858";
  #   "list.dropBackground" = "${dark-grey}";
  #   "list.highlightForeground" = "${light-blue}";
  #   "list.focusBackground" = "${dark-blue}";
  #   "list.focusForeground" = "${ivory}";
  #   "listFilterWidget.background" = "${maroon}";
  #   "listFilterWidget.outline" = "${black}00";
  #   "listFilterWidget.noMatchesOutline" = "${red}";
  #   "statusBar.foreground" = "${ivory}";
  #   "statusBar.background" = "${dark-blue}";
  #   "statusBarItem.hoverBackground" = "${blue-grey}";
  #   "statusBar.border" = "${blue-grey}";
  #   "statusBar.debuggingBackground" = "${brown}";
  #   "statusBar.debuggingForeground" = "${ivory}";
  #   "statusBar.noFolderBackground" = "${navy}";
  #   "statusBar.noFolderForeground" = "${ivory}";
  #   "statusBarItem.remoteBackground" = "${indigo}";
  #   "statusBarItem.remoteForeground" = "${ivory}";
  #   "titleBar.activeBackground" = "${navy}";
  #   "titleBar.activeForeground" = "${ivory}";
  #   "titleBar.inactiveBackground" = "${navy}";
  #   "titleBar.inactiveForeground" = "${ivory}";
  #   "titleBar.border" = "${black}00";
  #   "menubar.selectionForeground" = "${ivory}";
  #   "menubar.selectionBackground" = "${dark-blue}";
  #   "menubar.selectionBorder" = "${black}00";
  #   "menu.foreground" = "${ivory}";
  #   "menu.background" = "${dark-blue}";
  #   "menu.selectionForeground" = "${ivory}";
  #   "menu.selectionBackground" = "${blue-grey}";
  #   "menu.selectionBorder" = "${black}00";
  #   "menu.separatorBackground" = "${dark-grey}";
  #   "menu.border" = "${dark-grey}";
  #   "button.background" = "${blue-grey}";
  #   "button.foreground" = "${ivory}";
  #   "button.hoverBackground" = "${light-blue}";
  #   "button.secondaryForeground" = "${ivory}";
  #   "button.secondaryBackground" = "${dark-blue}";
  #   "button.secondaryHoverBackground" = "${dark-grey}";
  #   "input.background" = "${navy}";
  #   "input.border" = "${black}00";
  #   "input.foreground" = "${ivory}";
  #   "inputOption.activeBackground" = "${light-blue}50";
  #   "inputOption.activeBorder" = "${black}00";
  #   "inputOption.activeForeground" = "${ivory}";
  #   "input.placeholderForeground" = "${grey}";
  #   "textLink.foreground" = "${light-blue}";
  #   "editor.background" = "${navy}";
  #   "editor.foreground" = "${ivory}";
  #   "editorLineNumber.foreground" = "${grey}";
  #   "editorCursor.foreground" = "${ivory}";
  #   "editorCursor.background" = "${black}";
  #   "editor.selectionBackground" = "${dark-blue}";
  #   "editor.inactiveSelectionBackground" = "${dark-grey}";
  #   "editorWhitespace.foreground" = "${grey}";
  #   "editor.selectionHighlightBackground" = "${dark-grey}5e";
  #   "editor.selectionHighlightBorder" = "${black}00";
  #   "editor.findMatchBackground" = "${dark-grey}";
  #   "editor.findMatchBorder" = "${black}00";
  #   "editor.findMatchHighlightBackground" = "${maroon}83";
  #   "editor.findMatchHighlightBorder" = "${black}00";
  #   "editor.findRangeHighlightBackground" = "${dark-grey}32";
  #   "editor.findRangeHighlightBorder" = "${black}00";
  #   "editor.rangeHighlightBackground" = "${black}00";
  #   "editor.rangeHighlightBorder" = "${black}00";
  #   "editor.hoverHighlightBackground" = "${indigo}a7";
  #   "editor.wordHighlightStrongBackground" = "${indigo}a7";
  #   "editor.wordHighlightBackground" = "${dark-grey}54";
  #   "editor.lineHighlightBackground" = "${blue-grey}6a";
  #   "editor.lineHighlightBorder" = "${black}00";
  #   "editorLineNumber.activeForeground" = "${ivory}";
  #   "editorLink.activeForeground" = "${light-blue}";
  #   "editorIndentGuide.background" = "${dark-grey}";
  #   "editorIndentGuide.activeBackground" = "${light-grey}";
  #   "editorRuler.foreground" = "${dark-grey}";
  #   "editorBracketMatch.background" = "${black}00";
  #   "editorBracketMatch.border" = "${purple}";
  #   "editor.foldBackground" = "${dark-blue}cf";
  #   "editorOverviewRuler.background" = "${navy}";
  #   "editorOverviewRuler.border" = "${dark-grey}";
  #   "editorError.foreground" = "${red}";
  #   "editorError.background" = "${black}00";
  #   "editorError.border" = "${black}00";
  #   "editorWarning.foreground" = "${yellow}";
  #   "editorWarning.background" = "${black}00";
  #   "editorWarning.border" = "${black}00";
  #   "editorInfo.foreground" = "${light-blue}";
  #   "editorInfo.background" = "${black}00";
  #   "editorInfo.border" = "${black}00";
  #   "editorGutter.background" = "${navy}";
  #   "editorGutter.modifiedBackground" = "${cyan}";
  #   "editorGutter.addedBackground" = "${green}";
  #   "editorGutter.deletedBackground" = "${red}";
  #   "editorGutter.foldingControlForeground" = "${light-grey}";
  #   "editorCodeLens.foreground" = "${light-grey}";
  #   "editorGroup.border" = "${blue-grey}";
  #   "diffEditor.insertedTextBackground" = "${green}2c";
  #   "diffEditor.insertedTextBorder" = "${black}00";
  #   "diffEditor.removedTextBackground" = "${red}3a";
  #   "diffEditor.removedTextBorder" = "${black}00";
  #   "diffEditor.border" = "${blue-grey}";
  #   "panel.background" = "${navy}";
  #   "panel.border" = "${blue-grey}";
  #   "panelTitle.activeBorder" = "${ivory}";
  #   "panelTitle.activeForeground" = "${ivory}";
  #   "panelTitle.inactiveForeground" = "${grey}";
  #   "badge.background" = "${indigo}";
  #   "badge.foreground" = "${ivory}";
  #   "terminal.foreground" = "${ivory}";
  #   "terminal.selectionBackground" = "${ivory}50";
  #   "terminalCursor.background" = "${light-blue}";
  #   "terminalCursor.foreground" = "${ivory}";
  #   "terminal.border" = "${light-grey}68";
  #   "terminal.ansiBlack" = "${black}";
  #   "terminal.ansiBlue" = "${light-blue}";
  #   "terminal.ansiBrightBlack" = "${dark-grey}";
  #   "terminal.ansiBrightBlue" = "${light-grey}";
  #   "terminal.ansiBrightCyan" = "${light-blue}";
  #   "terminal.ansiBrightGreen" = "${lime}";
  #   "terminal.ansiBrightMagenta" = "${pink}";
  #   "terminal.ansiBrightRed" = "${orange}";
  #   "terminal.ansiBrightWhite" = "${white}";
  #   "terminal.ansiBrightYellow" = "${peach}";
  #   "terminal.ansiCyan" = "${cyan}";
  #   "terminal.ansiGreen" = "${green}";
  #   "terminal.ansiMagenta" = "${purple}";
  #   "terminal.ansiRed" = "${red}";
  #   "terminal.ansiWhite" = "${ivory}";
  #   "terminal.ansiYellow" = "${salmon}";
  #   "breadcrumb.background" = "${navy}";
  #   "breadcrumb.foreground" = "${grey}";
  #   "breadcrumb.focusForeground" = "${light-grey}";
  #   "editorGroupHeader.border" = "${black}00";
  #   "editorGroupHeader.tabsBackground" = "${dark-blue}";
  #   "editorGroupHeader.tabsBorder" = "${blue-grey}";
  #   "tab.activeForeground" = "${ivory}";
  #   "tab.border" = "${blue-grey}";
  #   "tab.activeBackground" = "${navy}";
  #   "tab.activeBorder" = "${black}00";
  #   "tab.activeBorderTop" = "${black}00";
  #   "tab.inactiveBackground" = "${dark-blue}";
  #   "tab.inactiveForeground" = "${ivory}";
  #   "scrollbarSlider.background" = "${dark-grey}80";
  #   "scrollbarSlider.hoverBackground" = "${dark-grey}";
  #   "scrollbarSlider.activeBackground" = "${dark-grey}";
  #   "progressBar.background" = "${green}";
  #   "widget.shadow" = "${black}c7";
  #   "editorWidget.foreground" = "${ivory}";
  #   "editorWidget.background" = "${navy}";
  #   "editorWidget.resizeBorder" = "${grey}";
  #   "pickerGroup.border" = "${blue-grey}";
  #   "pickerGroup.foreground" = "${light-blue}";
  #   "debugToolBar.background" = "${dark-grey}";
  #   "debugToolBar.border" = "${navy}";
  #   "notifications.foreground" = "${ivory}";
  #   "notifications.background" = "${navy}";
  #   "notificationToast.border" = "${blue-grey}";
  #   "notificationsErrorIcon.foreground" = "${red}";
  #   "notificationsWarningIcon.foreground" = "${yellow}";
  #   "notificationsInfoIcon.foreground" = "${light-blue}";
  #   "notificationCenter.border" = "${grey}";
  #   "notificationCenterHeader.foreground" = "${ivory}";
  #   "notificationCenterHeader.background" = "${navy}";
  #   "notifications.border" = "${grey}";
  #   "gitDecoration.addedResourceForeground" = "${green}";
  #   "gitDecoration.conflictingResourceForeground" = "${red}";
  #   "gitDecoration.deletedResourceForeground" = "${red}";
  #   "gitDecoration.ignoredResourceForeground" = "${dark-grey}";
  #   "gitDecoration.modifiedResourceForeground" = "${yellow}";
  #   "gitDecoration.stageDeletedResourceForeground" = "${red}";
  #   "gitDecoration.stageModifiedResourceForeground" = "${yellow}";
  #   "gitDecoration.submoduleResourceForeground" = "${light-blue}";
  #   "gitDecoration.untrackedResourceForeground" = "${light-grey}";
  #   "editorMarkerNavigation.background" = "${navy}";
  #   "editorMarkerNavigationError.background" = "${red}";
  #   "editorMarkerNavigationWarning.background" = "${yellow}";
  #   "editorMarkerNavigationInfo.background" = "${light-blue}";
  #   "merge.currentHeaderBackground" = "${cyan}62";
  #   "merge.currentContentBackground" = "${cyan}34";
  #   "merge.incomingHeaderBackground" = "${light-blue}62";
  #   "merge.incomingContentBackground" = "${light-blue}34";
  #   "merge.commonHeaderBackground" = "${blue-grey}62";
  #   "merge.commonContentBackground" = "${blue-grey}34";
  #   "editorSuggestWidget.background" = "${navy}";
  #   "editorSuggestWidget.border" = "${blue-grey}";
  #   "editorSuggestWidget.foreground" = "${ivory}";
  #   "editorSuggestWidget.highlightForeground" = "${light-blue}";
  #   "editorSuggestWidget.selectedBackground" = "${dark-blue}";
  #   "editorHoverWidget.foreground" = "${ivory}";
  #   "editorHoverWidget.background" = "${navy}";
  #   "editorHoverWidget.border" = "${blue-grey}";
  #   "peekView.border" = "${blue-grey}";
  #   "peekViewEditor.background" = "${dark-blue}";
  #   "peekViewEditorGutter.background" = "${dark-blue}";
  #   "peekViewEditor.matchHighlightBackground" = "${peach}66";
  #   "peekViewEditor.matchHighlightBorder" = "${black}00";
  #   "peekViewResult.background" = "${dark-blue}";
  #   "peekViewResult.fileForeground" = "${ivory}";
  #   "peekViewResult.lineForeground" = "${ivory}";
  #   "peekViewResult.matchHighlightBackground" = "${salmon}3c";
  #   "peekViewResult.selectionBackground" = "${cyan}4a";
  #   "peekViewResult.selectionForeground" = "${ivory}";
  #   "peekViewTitle.background" = "${dark-blue}";
  #   "peekViewTitleDescription.foreground" = "${ivory}";
  #   "peekViewTitleLabel.foreground" = "${ivory}";
  #   "icon.foreground" = "${ivory}";
  #   "checkbox.background" = "${navy}";
  #   "checkbox.foreground" = "${ivory}";
  #   "checkbox.border" = "${black}00";
  #   "dropdown.background" = "${navy}";
  #   "dropdown.foreground" = "${ivory}";
  #   "dropdown.border" = "${black}00";
  #   "minimapGutter.addedBackground" = "${green}";
  #   "minimapGutter.modifiedBackground" = "${cyan}";
  #   "minimapGutter.deletedBackground" = "${red}";
  #   "minimap.findMatchHighlight" = "${dark-grey}";
  #   "minimap.selectionHighlight" = "${dark-blue}";
  #   "minimap.errorHighlight" = "${red}";
  #   "minimap.warningHighlight" = "${yellow}";
  #   "minimap.background" = "${navy}";
  #   "sideBar.dropBackground" = "${dark-grey}";
  #   "editorGroup.emptyBackground" = "${navy}";
  #   "panelSection.border" = "${light-grey}68";
  #   "statusBarItem.activeBackground" = "${white}25";
  #   "settings.headerForeground" = "${ivory}";
  #   "settings.focusedRowBackground" = "${white}07";
  #   "walkThrough.embeddedEditorBackground" = "${black}50";
  #   "breadcrumb.activeSelectionForeground" = "${light-grey}";
  #   "editorGutter.commentRangeForeground" = "${light-grey}";
  #   "debugExceptionWidget.background" = "${dark-grey}";
  #   "debugExceptionWidget.border" = "${navy}";
  # };
  # "workbench.colorTheme" = "Dark+";
  "workbench.commandPalette.experimental.suggestCommands" = true;
  "workbench.editor.closeOnFileDelete" = true;
  "workbench.editor.empty.hint" = "hidden";
  "workbench.editor.enablePreview" = false;
  "workbench.editor.enablePreviewFromCodeNavigation" = true;
  "workbench.editor.highlightModifiedTabs" = true;
  "workbench.editor.pinnedTabSizing" = "shrink";
  "workbench.editor.revealIfOpen" = true;
  "workbench.iconTheme" = "vscode-icons";
  "workbench.layoutControl.enabled" = false;
  "workbench.panel.opensMaximized" = "never";
  "workbench.sideBar.location" = "right";
  "workbench.startupEditor" = "none";
  "workbench.tree.enableStickyScroll" = true;
  "workbench.view.alwaysShowHeaderActions" = true;
  "workbench.welcomePage.walkthroughs.openOnInstall" = false;
}
