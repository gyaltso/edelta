
package edelta.tests

import edelta.edelta.EdeltaPackage
import edelta.lib.AbstractEdelta
import edelta.validation.EdeltaValidator
import org.eclipse.xtext.diagnostics.Diagnostic
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static edelta.edelta.EdeltaPackage.Literals.*

@RunWith(XtextRunner)
@InjectWith(EdeltaInjectorProviderCustom)
class EdeltaValidatorTest extends EdeltaAbstractTest {

	@Test
	def void testEmptyProgram() {
		''''''.parse.assertNoErrors
	}

	@Test
	def void testCanReferToMetamodel() {
		referenceToMetamodel.parseWithTestEcore.assertNoErrors
	}

	@Test
	def void testUseImportedJavaTypes() {
		useImportedJavaTypes.parse.assertNoErrors
	}

	@Test
	def void testReferenceToCreatedEClass() {
		referenceToCreatedEClass.parseWithTestEcore.assertNoErrors
	}

	@Test
	def void testReferenceToCreatedEAttribute() {
		referenceToCreatedEAttributeRenamed.parseWithTestEcore.assertNoErrors
	}

	@Test
	def void testValidUseAs() {
		'''
		import edelta.tests.additional.MyCustomEdelta;
		use MyCustomEdelta as foo
		'''.parse.assertNoIssues
	}

	@Test
	def void testInvalidUseAsNotAnEdelta() {
		val input = '''
		import java.util.List;
		use List as foo
		'''
		input.parse.assertError(
			EDELTA_USE_AS,
			EdeltaValidator.TYPE_MISMATCH,
			input.lastIndexOf("List"), 4,
			"Not a valid type: must be an " + AbstractEdelta.name
		)
	}

	@Test
	def void testInvalidUseAsAbstractEdelta() {
		val input = '''
		import edelta.tests.additional.MyCustomAbstractEdelta;
		use MyCustomAbstractEdelta as foo
		'''
		input.parse.assertError(
			EDELTA_USE_AS,
			EdeltaValidator.TYPE_MISMATCH,
			input.lastIndexOf("MyCustomAbstractEdelta"), "MyCustomAbstractEdelta".length,
			"Cannot be an abstract type"
		)
	}

	@Test
	def void testInvalidUseAsUnresolvedProxy() {
		val input = '''
		use Unknown as foo
		'''
		input.parse.assertErrorsAsStrings(
			"Unknown cannot be resolved to a type."
		)
	}

	@Test
	def void testTimeoutInCancelIndicator() {
		val input = '''
			import org.eclipse.emf.ecore.EPackage

			metamodel "foo"
			
			def op(EPackage c) : void {
				var i = 10;
				while (i >= 0) {
					Thread.sleep(1000);
					i++
				}
				// this will never be executed
				c.abstract = true
			}
			
			modifyEcore aTest epackage foo {
				op(it)
			}
		'''
		val lastOpenCurlyBracket = input.lastIndexOf("{")
		val lastClosedCurlyBracket = input.lastIndexOf("}")
		input.parseWithTestEcore.assertWarning(
			EdeltaPackage.eINSTANCE.edeltaModifyEcoreOperation,
			EdeltaValidator.INTERPRETER_TIMEOUT,
			lastOpenCurlyBracket, lastClosedCurlyBracket - lastOpenCurlyBracket + 1,
			"Timeout interpreting initialization block"
		)
	}

	@Test
	def void testUnresolvedEcoreReference() {
		'''
		metamodel "foo"
		
		modifyEcore aTest epackage foo {
			ecoreref(NonExistant)
			ecoreref(FooClass)
		}
		'''.parseWithTestEcore.assertErrorsAsStrings("NonExistant cannot be resolved.")
	}

	@Test
	def void testNoDanglingReferencesAfterInterpretation() {
		'''
		metamodel "foo"
		
		modifyEcore aTest epackage foo {
			ecoreref(foo.FooClass).EPackage.EClassifiers.remove(ecoreref(foo.FooClass))
		}
		'''.parseWithTestEcore.assertNoErrors
	}

	@Test
	def void testCallMethodOnRenanedEClassInModifyEcore() {
		val prog =
		'''
		metamodel "foo"

		modifyEcore aTest epackage foo {
			ecoreref(foo.FooClass).name = "RenamedClass"
			ecoreref(RenamedClass).getEAllStructuralFeatures
		}
		'''.parseWithTestEcore
		prog.assertNoErrors
	}

	@Test
	def void testCallMethodOnQualifiedRenanedEClassInModifyEcore() {
		val prog =
		'''
		metamodel "foo"

		modifyEcore aTest epackage foo {
			ecoreref(foo.FooClass).name = "RenamedClass"
			ecoreref(foo.RenamedClass).getEAllStructuralFeatures
		}
		'''.parseWithTestEcore
		prog.assertNoErrors
	}

	@Test
	def void testCallNonExistingMethodOnRenanedEClassInModifyEcore() {
		val prog =
		'''
		metamodel "foo"

		modifyEcore aTest epackage foo {
			ecoreref(foo.FooClass).name = "RenamedClass"
			ecoreref(RenamedClass).nonExistant("an arg")
			ecoreref(RenamedClass).sugarSet = "an arg"
			"a string".sugarSet = "an arg"
		}
		'''.parseWithTestEcore
		prog.assertErrorsAsStrings
		('''
		The method nonExistant(String) is undefined for the type EClass
		The method sugarSet(String) is undefined for the type EClass
		The method sugarSet(String) is undefined for the type String
		''')
	}

	@Test
	def void testReferenceToAddedAttributeofRenamedClassInModifyEcore() {
		'''
		metamodel "foo"

		modifyEcore aTest epackage foo {
			ecoreref(foo.FooClass).name = "RenamedClass"
			ecoreref(RenamedClass).EStructuralFeatures.add(
				newEAttribute("addedAttribute"))
			ecoreref(RenamedClass.addedAttribute)
		}
		'''.parseWithTestEcore.assertNoErrors
	}

	@Test
	def void testReferenceToAddedAttributeofRenamedClassInModifyEcore2() {
		'''
		import org.eclipse.emf.ecore.EClass

		metamodel "foo"

		modifyEcore aTest epackage foo {
			ecoreref(foo.FooClass).name = "RenamedClass"
			ecoreref(RenamedClass).EStructuralFeatures += newEAttribute("added")
			ecoreref(RenamedClass.added)
		}
		'''.parseWithTestEcore.assertNoErrors
	}

	@Test
	def void testReferenceToRenamedClassInModifyEcore() {
		'''
		import org.eclipse.emf.ecore.EClass

		metamodel "foo"

		modifyEcore aTest epackage foo {
			ecoreref(foo.FooClass).name = "RenamedClass"
			ecoreref(foo.RenamedClass) => [abstract = true]
			ecoreref(foo.RenamedClass).setAbstract(true)
			ecoreref(foo.RenamedClass).abstract = true
		}
		'''.parseWithTestEcore.assertNoErrors
	}

	@Test
	def void testReferenceToUnknownEPackageInModifyEcore() {
		'''
		import org.eclipse.emf.ecore.EClass

		modifyEcore aTest epackage foo {
			
		}
		'''.parseWithTestEcore.assertError(
			EdeltaPackage.eINSTANCE.edeltaModifyEcoreOperation,
			Diagnostic.LINKING_DIAGNOSTIC,
			"foo cannot be resolved."
		)
	}

	@Test
	def void testValidLibMethodsInModifyEcore() {
		modifyEcoreUsingLibMethods.parseWithTestEcore.assertNoErrors
	}

	@Test
	def void testDuplicateDeclarations() {
		val input = '''
		import java.util.List
		import org.eclipse.emf.ecore.EPackage
		
		metamodel "foo"

		def myFun(List<Integer> l) {}
		def myFun(List<String> l) {}
		def anotherFun(List<String> l) {} // OK, different params
		def anotherDuplicate(EPackage p) {} // conflicts with modifyEcore

		modifyEcore aTest epackage foo {}
		modifyEcore aTest epackage foo {}
		modifyEcore anotherDuplicate epackage foo {} // implicit Java method param: EPackage
		modifyEcore anotherFun epackage foo {} // OK, different params
		'''
		input.parseWithTestEcore => [
			assertError(
				EdeltaPackage.eINSTANCE.edeltaOperation,
				EdeltaValidator.DUPLICATE_DECLARATION,
				input.indexOf("anotherDuplicate"), "anotherDuplicate".length,
				"Duplicate definition 'anotherDuplicate'"
			)
			assertError(
				EdeltaPackage.eINSTANCE.edeltaModifyEcoreOperation,
				EdeltaValidator.DUPLICATE_DECLARATION,
				input.lastIndexOf("anotherDuplicate"), "anotherDuplicate".length,
				"Duplicate definition 'anotherDuplicate'"
			)
			assertErrorsAsStrings(
				'''
				Duplicate definition 'aTest'
				Duplicate definition 'aTest'
				Duplicate definition 'anotherDuplicate'
				Duplicate definition 'anotherDuplicate'
				Duplicate definition 'myFun'
				Duplicate definition 'myFun'
				'''
			)
		]
	}

	@Test
	def void testReferenceToCreatedEClassRenamed() {
		referenceToCreatedEClassRenamed
		.parseWithTestEcore.assertNoErrors
	}
}
