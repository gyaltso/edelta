package edelta.tests;

import com.google.common.base.Objects;
import com.google.common.collect.Iterables;
import com.google.inject.Inject;
import com.google.inject.Provider;
import edelta.edelta.EdeltaEcoreDirectReference;
import edelta.edelta.EdeltaEcoreQualifiedReference;
import edelta.edelta.EdeltaEcoreReferenceExpression;
import edelta.edelta.EdeltaModifyEcoreOperation;
import edelta.edelta.EdeltaProgram;
import edelta.tests.EdeltaInjectorProvider;
import edelta.tests.input.Inputs;
import java.nio.file.Paths;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EDataType;
import org.eclipse.emf.ecore.EEnum;
import org.eclipse.emf.ecore.EEnumLiteral;
import org.eclipse.emf.ecore.ENamedElement;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.EcoreFactory;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.xmi.XMIResource;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.diagnostics.Severity;
import org.eclipse.xtext.resource.XtextResourceSet;
import org.eclipse.xtext.testing.InjectWith;
import org.eclipse.xtext.testing.XtextRunner;
import org.eclipse.xtext.testing.util.ParseHelper;
import org.eclipse.xtext.testing.validation.ValidationTestHelper;
import org.eclipse.xtext.validation.Issue;
import org.eclipse.xtext.xbase.XBlockExpression;
import org.eclipse.xtext.xbase.XExpression;
import org.eclipse.xtext.xbase.XVariableDeclaration;
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Extension;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Assert;
import org.junit.runner.RunWith;

@RunWith(XtextRunner.class)
@InjectWith(EdeltaInjectorProvider.class)
@SuppressWarnings("all")
public abstract class EdeltaAbstractTest {
  @Inject
  private Provider<XtextResourceSet> resourceSetProvider;
  
  @Inject
  @Extension
  protected ParseHelper<EdeltaProgram> _parseHelper;
  
  @Inject
  @Extension
  protected ValidationTestHelper _validationTestHelper;
  
  @Inject
  @Extension
  protected IJvmModelAssociations _iJvmModelAssociations;
  
  @Extension
  protected Inputs _inputs = new Inputs();
  
  protected static String ECORE_PATH = "src/edelta/tests/input/models/EcoreForTests.ecore";
  
  protected static String PERSON_LIST_ECORE = "PersonList.ecore";
  
  protected static String PERSON_LIST_ECORE_PATH = ("src/edelta/tests/input/models/" + EdeltaAbstractTest.PERSON_LIST_ECORE);
  
  protected EdeltaProgram parseWithTestEcore(final CharSequence input) {
    try {
      return this._parseHelper.parse(input, this.resourceSetWithTestEcore());
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  protected EdeltaProgram parseWithTestEcores(final CharSequence input) {
    try {
      return this._parseHelper.parse(input, this.resourceSetWithTestEcores());
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  protected EdeltaProgram parseWithLoadedEcore(final String path, final CharSequence input) {
    try {
      final XtextResourceSet resourceSet = this.resourceSetProvider.get();
      resourceSet.getResource(this.createFileURIFromPath(EdeltaAbstractTest.ECORE_PATH), true);
      final URI uri = this.createFileURIFromPath(path);
      resourceSet.getResource(uri, true);
      final EdeltaProgram prog = this._parseHelper.parse(input, resourceSet);
      return prog;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  protected URI createFileURIFromPath(final String path) {
    return URI.createFileURI(
      Paths.get(path).toAbsolutePath().toString());
  }
  
  protected ResourceSet resourceSetWithTestEcore() {
    ResourceSet _xblockexpression = null;
    {
      final XtextResourceSet resourceSet = this.resourceSetProvider.get();
      _xblockexpression = this.addEPackageForTests(resourceSet);
    }
    return _xblockexpression;
  }
  
  protected ResourceSet addEPackageForTests(final ResourceSet resourceSet) {
    return this.createTestResource(resourceSet, "foo", this.EPackageForTests());
  }
  
  protected ResourceSet resourceSetWithTestEcores() {
    ResourceSet _xblockexpression = null;
    {
      final ResourceSet resourceSet = this.resourceSetWithTestEcore();
      _xblockexpression = this.addEPackageForTests2(resourceSet);
    }
    return _xblockexpression;
  }
  
  protected ResourceSet addEPackageForTests2(final ResourceSet resourceSet) {
    return this.createTestResource(resourceSet, "bar.", this.EPackageForTests2());
  }
  
  protected ResourceSet createTestResource(final ResourceSet resourceSet, final String ecoreName, final EPackage epackage) {
    ResourceSet _xblockexpression = null;
    {
      final Resource resource = resourceSet.createResource(URI.createURI((ecoreName + ".ecore")));
      EList<EObject> _contents = resource.getContents();
      _contents.add(epackage);
      _xblockexpression = resourceSet;
    }
    return _xblockexpression;
  }
  
  protected EPackage EPackageForTests() {
    EPackage _xblockexpression = null;
    {
      EPackage _createEPackage = EcoreFactory.eINSTANCE.createEPackage();
      final Procedure1<EPackage> _function = (EPackage it) -> {
        it.setName("foo");
        it.setNsPrefix("foo");
        it.setNsURI("http://foo");
      };
      final EPackage fooPackage = ObjectExtensions.<EPackage>operator_doubleArrow(_createEPackage, _function);
      EList<EClassifier> _eClassifiers = fooPackage.getEClassifiers();
      EClass _createEClass = EcoreFactory.eINSTANCE.createEClass();
      final Procedure1<EClass> _function_1 = (EClass it) -> {
        it.setName("FooClass");
        EList<EStructuralFeature> _eStructuralFeatures = it.getEStructuralFeatures();
        EAttribute _createEAttribute = EcoreFactory.eINSTANCE.createEAttribute();
        final Procedure1<EAttribute> _function_2 = (EAttribute it_1) -> {
          it_1.setName("myAttribute");
        };
        EAttribute _doubleArrow = ObjectExtensions.<EAttribute>operator_doubleArrow(_createEAttribute, _function_2);
        _eStructuralFeatures.add(_doubleArrow);
        EList<EStructuralFeature> _eStructuralFeatures_1 = it.getEStructuralFeatures();
        EReference _createEReference = EcoreFactory.eINSTANCE.createEReference();
        final Procedure1<EReference> _function_3 = (EReference it_1) -> {
          it_1.setName("myReference");
        };
        EReference _doubleArrow_1 = ObjectExtensions.<EReference>operator_doubleArrow(_createEReference, _function_3);
        _eStructuralFeatures_1.add(_doubleArrow_1);
      };
      EClass _doubleArrow = ObjectExtensions.<EClass>operator_doubleArrow(_createEClass, _function_1);
      _eClassifiers.add(_doubleArrow);
      EList<EClassifier> _eClassifiers_1 = fooPackage.getEClassifiers();
      EDataType _createEDataType = EcoreFactory.eINSTANCE.createEDataType();
      final Procedure1<EDataType> _function_2 = (EDataType it) -> {
        it.setName("FooDataType");
      };
      EDataType _doubleArrow_1 = ObjectExtensions.<EDataType>operator_doubleArrow(_createEDataType, _function_2);
      _eClassifiers_1.add(_doubleArrow_1);
      EList<EClassifier> _eClassifiers_2 = fooPackage.getEClassifiers();
      EEnum _createEEnum = EcoreFactory.eINSTANCE.createEEnum();
      final Procedure1<EEnum> _function_3 = (EEnum it) -> {
        it.setName("FooEnum");
        EList<EEnumLiteral> _eLiterals = it.getELiterals();
        EEnumLiteral _createEEnumLiteral = EcoreFactory.eINSTANCE.createEEnumLiteral();
        final Procedure1<EEnumLiteral> _function_4 = (EEnumLiteral it_1) -> {
          it_1.setName("FooEnumLiteral");
        };
        EEnumLiteral _doubleArrow_2 = ObjectExtensions.<EEnumLiteral>operator_doubleArrow(_createEEnumLiteral, _function_4);
        _eLiterals.add(_doubleArrow_2);
      };
      EEnum _doubleArrow_2 = ObjectExtensions.<EEnum>operator_doubleArrow(_createEEnum, _function_3);
      _eClassifiers_2.add(_doubleArrow_2);
      _xblockexpression = fooPackage;
    }
    return _xblockexpression;
  }
  
  protected EPackage EPackageForTests2() {
    EPackage _xblockexpression = null;
    {
      EPackage _createEPackage = EcoreFactory.eINSTANCE.createEPackage();
      final Procedure1<EPackage> _function = (EPackage it) -> {
        it.setName("bar");
        it.setNsPrefix("bar");
        it.setNsURI("http://bar");
      };
      final EPackage fooPackage = ObjectExtensions.<EPackage>operator_doubleArrow(_createEPackage, _function);
      EList<EClassifier> _eClassifiers = fooPackage.getEClassifiers();
      EClass _createEClass = EcoreFactory.eINSTANCE.createEClass();
      final Procedure1<EClass> _function_1 = (EClass it) -> {
        it.setName("BarClass");
        EList<EStructuralFeature> _eStructuralFeatures = it.getEStructuralFeatures();
        EAttribute _createEAttribute = EcoreFactory.eINSTANCE.createEAttribute();
        final Procedure1<EAttribute> _function_2 = (EAttribute it_1) -> {
          it_1.setName("myAttribute");
        };
        EAttribute _doubleArrow = ObjectExtensions.<EAttribute>operator_doubleArrow(_createEAttribute, _function_2);
        _eStructuralFeatures.add(_doubleArrow);
        EList<EStructuralFeature> _eStructuralFeatures_1 = it.getEStructuralFeatures();
        EReference _createEReference = EcoreFactory.eINSTANCE.createEReference();
        final Procedure1<EReference> _function_3 = (EReference it_1) -> {
          it_1.setName("myReference");
        };
        EReference _doubleArrow_1 = ObjectExtensions.<EReference>operator_doubleArrow(_createEReference, _function_3);
        _eStructuralFeatures_1.add(_doubleArrow_1);
      };
      EClass _doubleArrow = ObjectExtensions.<EClass>operator_doubleArrow(_createEClass, _function_1);
      _eClassifiers.add(_doubleArrow);
      EList<EClassifier> _eClassifiers_1 = fooPackage.getEClassifiers();
      EDataType _createEDataType = EcoreFactory.eINSTANCE.createEDataType();
      final Procedure1<EDataType> _function_2 = (EDataType it) -> {
        it.setName("BarDataType");
      };
      EDataType _doubleArrow_1 = ObjectExtensions.<EDataType>operator_doubleArrow(_createEDataType, _function_2);
      _eClassifiers_1.add(_doubleArrow_1);
      _xblockexpression = fooPackage;
    }
    return _xblockexpression;
  }
  
  protected void assertErrorsAsStrings(final EObject o, final CharSequence expected) {
    final Function1<Issue, Boolean> _function = (Issue it) -> {
      Severity _severity = it.getSeverity();
      return Boolean.valueOf(Objects.equal(_severity, Severity.ERROR));
    };
    final Function1<Issue, String> _function_1 = (Issue it) -> {
      return it.getMessage();
    };
    this.assertEqualsStrings(expected.toString().trim(), 
      IterableExtensions.join(IterableExtensions.<String>sort(IterableExtensions.<Issue, String>map(IterableExtensions.<Issue>filter(this._validationTestHelper.validate(o), _function), _function_1)), "\n"));
  }
  
  protected void assertEqualsStrings(final CharSequence expected, final CharSequence actual) {
    Assert.assertEquals(expected.toString().replaceAll("\r", ""), actual.toString().replaceAll("\r", ""));
  }
  
  protected void assertNamedElements(final Iterable<? extends ENamedElement> elements, final CharSequence expected) {
    final Function1<ENamedElement, String> _function = (ENamedElement it) -> {
      return it.getName();
    };
    String _join = IterableExtensions.join(IterableExtensions.map(elements, _function), "\n");
    String _plus = (_join + "\n");
    this.assertEqualsStrings(expected, _plus);
  }
  
  protected EPackage getEPackageByName(final EdeltaProgram context, final String packagename) {
    final Function1<XMIResource, EPackage> _function = (XMIResource it) -> {
      EObject _head = IterableExtensions.<EObject>head(it.getContents());
      return ((EPackage) _head);
    };
    final Function1<EPackage, Boolean> _function_1 = (EPackage it) -> {
      String _name = it.getName();
      return Boolean.valueOf(Objects.equal(_name, packagename));
    };
    return IterableExtensions.<EPackage>findFirst(IterableExtensions.<XMIResource, EPackage>map(Iterables.<XMIResource>filter(context.eResource().getResourceSet().getResources(), XMIResource.class), _function), _function_1);
  }
  
  protected EClassifier getEClassifierByName(final EdeltaProgram context, final String packagename, final String classifiername) {
    final Function1<EClassifier, Boolean> _function = (EClassifier it) -> {
      String _name = it.getName();
      return Boolean.valueOf(Objects.equal(_name, classifiername));
    };
    return IterableExtensions.<EClassifier>findFirst(this.getEPackageByName(context, packagename).getEClassifiers(), _function);
  }
  
  protected EdeltaModifyEcoreOperation lastModifyEcoreOperation(final EdeltaProgram p) {
    return IterableExtensions.<EdeltaModifyEcoreOperation>last(p.getModifyEcoreOperations());
  }
  
  protected EClass getLastCopiedEPackageLastEClass(final EObject context) {
    EClass _xblockexpression = null;
    {
      final EPackage copiedEPackage = this.getLastCopiedEPackage(context);
      EClassifier _last = IterableExtensions.<EClassifier>last(copiedEPackage.getEClassifiers());
      _xblockexpression = ((EClass) _last);
    }
    return _xblockexpression;
  }
  
  protected EClass getLastCopiedEPackageFirstEClass(final EObject context) {
    EClass _xblockexpression = null;
    {
      final EPackage copiedEPackage = this.getLastCopiedEPackage(context);
      EClassifier _head = IterableExtensions.<EClassifier>head(copiedEPackage.getEClassifiers());
      _xblockexpression = ((EClass) _head);
    }
    return _xblockexpression;
  }
  
  protected EClass getLastCopiedEPackageFirstEClass(final EObject context, final String nameToSearch) {
    EClass _xblockexpression = null;
    {
      final EPackage p = this.getLastCopiedEPackage(context);
      final Function1<EClassifier, Boolean> _function = (EClassifier it) -> {
        String _name = it.getName();
        return Boolean.valueOf(Objects.equal(_name, nameToSearch));
      };
      EClassifier _findFirst = IterableExtensions.<EClassifier>findFirst(p.getEClassifiers(), _function);
      _xblockexpression = ((EClass) _findFirst);
    }
    return _xblockexpression;
  }
  
  protected EPackage getLastCopiedEPackage(final EObject context) {
    return IterableExtensions.<EPackage>last(this.getCopiedEPackages(context));
  }
  
  protected Iterable<EPackage> getCopiedEPackages(final EObject context) {
    return Iterables.<EPackage>filter(context.eResource().getContents(), EPackage.class);
  }
  
  protected EClassifier getEClassiferByName(final EPackage p, final String nameToSearch) {
    final Function1<EClassifier, Boolean> _function = (EClassifier it) -> {
      String _name = it.getName();
      return Boolean.valueOf(Objects.equal(_name, nameToSearch));
    };
    return IterableExtensions.<EClassifier>findFirst(p.getEClassifiers(), _function);
  }
  
  protected EStructuralFeature getEStructuralFeatureByName(final EClassifier e, final String nameToSearch) {
    final Function1<EStructuralFeature, Boolean> _function = (EStructuralFeature it) -> {
      String _name = it.getName();
      return Boolean.valueOf(Objects.equal(_name, nameToSearch));
    };
    return IterableExtensions.<EStructuralFeature>findFirst(((EClass) e).getEStructuralFeatures(), _function);
  }
  
  protected EAttribute getEAttributeByName(final EClassifier e, final String nameToSearch) {
    final Function1<EAttribute, Boolean> _function = (EAttribute it) -> {
      String _name = it.getName();
      return Boolean.valueOf(Objects.equal(_name, nameToSearch));
    };
    return IterableExtensions.<EAttribute>findFirst(Iterables.<EAttribute>filter(((EClass) e).getEStructuralFeatures(), EAttribute.class), _function);
  }
  
  protected EEnumLiteral getEEnumLiteralByName(final EClassifier e, final String nameToSearch) {
    final Function1<EEnumLiteral, Boolean> _function = (EEnumLiteral it) -> {
      String _name = it.getName();
      return Boolean.valueOf(Objects.equal(_name, nameToSearch));
    };
    return IterableExtensions.<EEnumLiteral>findFirst(((EEnum) e).getELiterals(), _function);
  }
  
  protected EdeltaEcoreReferenceExpression getEdeltaEcoreReferenceExpression(final XExpression e) {
    return ((EdeltaEcoreReferenceExpression) e);
  }
  
  protected EdeltaEcoreDirectReference getEdeltaEcoreDirectReference(final EObject e) {
    return ((EdeltaEcoreDirectReference) e);
  }
  
  protected EdeltaEcoreQualifiedReference getEdeltaEcoreQualifiedReference(final EObject e) {
    return ((EdeltaEcoreQualifiedReference) e);
  }
  
  protected XExpression getBlockLastExpression(final XExpression e) {
    return IterableExtensions.<XExpression>last(((XBlockExpression) e).getExpressions());
  }
  
  protected XBlockExpression getBlock(final XExpression e) {
    return ((XBlockExpression) e);
  }
  
  protected XVariableDeclaration getVariableDeclaration(final XExpression e) {
    return ((XVariableDeclaration) e);
  }
  
  protected EdeltaModifyEcoreOperation getModifyEcoreOperation(final XExpression e) {
    return ((EdeltaModifyEcoreOperation) e);
  }
  
  protected EClass getLastEClass(final EPackage ePackage) {
    EClassifier _last = IterableExtensions.<EClassifier>last(ePackage.getEClassifiers());
    return ((EClass) _last);
  }
  
  protected EClass getFirstEClass(final EPackage ePackage) {
    EClassifier _head = IterableExtensions.<EClassifier>head(ePackage.getEClassifiers());
    return ((EClass) _head);
  }
  
  protected EdeltaEcoreReferenceExpression ecoreReferenceExpression(final CharSequence ecoreRefString) {
    return this.lastEcoreReferenceExpression(this.parseInsideModifyEcoreWithTestMetamodelFoo(ecoreRefString));
  }
  
  protected EdeltaProgram parseInsideModifyEcoreWithTestMetamodelFoo(final CharSequence body) {
    return this.parseWithTestEcore(this.inputInsideModifyEcoreWithTestMetamodelFoo(body));
  }
  
  protected CharSequence inputInsideModifyEcoreWithTestMetamodelFoo(final CharSequence body) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("metamodel \"foo\"");
    _builder.newLine();
    _builder.newLine();
    _builder.append("modifyEcore aTest epackage foo {");
    _builder.newLine();
    _builder.append("\t");
    _builder.append(body, "\t");
    _builder.newLineIfNotEmpty();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }
  
  protected EdeltaEcoreReferenceExpression lastEcoreReferenceExpression(final EdeltaProgram p) {
    XExpression _blockLastExpression = this.getBlockLastExpression(this.lastModifyEcoreOperation(p).getBody());
    return ((EdeltaEcoreReferenceExpression) _blockLastExpression);
  }
}
