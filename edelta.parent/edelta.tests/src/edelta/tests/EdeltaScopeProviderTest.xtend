/*
 * generated by Xtext 2.10.0
 */
package edelta.tests

import com.google.inject.Inject
import edelta.edelta.EdeltaEcoreReferenceExpression
import edelta.edelta.EdeltaPackage
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.scoping.IScopeProvider
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

@RunWith(XtextRunner)
@InjectWith(EdeltaInjectorProviderCustom)
class EdeltaScopeProviderTest extends EdeltaAbstractTest {

	@Inject extension IScopeProvider

	@Test
	def void testSuperScope() {
		// just check that nothing wrong happens when we call super.getScope
		'''
		metamodel "foo"
		
		this.
		'''.parse.lastExpression.getScope(EdeltaPackage.eINSTANCE.edeltaProgram_Main)
	}

	@Test
	def void testScopeForMetamodel() {
		referenceToMetamodel.parseWithTestEcore.
			assertScope(EdeltaPackage.eINSTANCE.edeltaProgram_Metamodels,
			'''
			foo
			'''
			)
		// we skip nsURI references, like http://foo
	}

	@Test
	def void testScopeForMetamodels() {
		referencesToMetamodels.parseWithTestEcores.
			assertScope(EdeltaPackage.eINSTANCE.edeltaProgram_Metamodels,
			'''
			foo
			bar
			'''
			)
	}

	@Test
	def void testScopeForEnamedElementInProgram() {
		referenceToMetamodel.parseWithTestEcore.
			assertScope(EdeltaPackage.eINSTANCE.edeltaEcoreReference_Enamedelement,
			'''
			FooClass
			myAttribute
			myReference
			FooDataType
			FooEnum
			FooEnumLiteral
			foo
			''')
	}

	@Test
	def void testScopeForEnamedElementInEcoreReferenceExpression() {
		'''
		metamodel "foo"
		ecoreref 
		'''.parseWithTestEcore.lastExpression.
			assertScope(EdeltaPackage.eINSTANCE.edeltaEcoreReference_Enamedelement,
			'''
			FooClass
			myAttribute
			myReference
			FooDataType
			FooEnum
			FooEnumLiteral
			foo
			''')
	}

	@Test
	def void testScopeForEnamedElementInEcoreReferenceExpressionWithTwoMetamodels() {
		'''
		metamodel "foo"
		metamodel "bar"
		ecoreref 
		'''.parseWithTestEcores.lastExpression.
			assertScope(EdeltaPackage.eINSTANCE.edeltaEcoreReference_Enamedelement,
			'''
			FooClass
			myAttribute
			myReference
			FooDataType
			FooEnum
			FooEnumLiteral
			BarClass
			myAttribute
			myReference
			BarDataType
			foo
			bar
			''')
	}

	@Test
	def void testScopeForEnamedElementInEcoreReferenceExpressionQualifiedPackage() {
		'''
		metamodel "foo"
		metamodel "bar"
		ecoreref foo.
		'''.parseWithTestEcores.
			lastExpression.
			edeltaEcoreReferenceExpression.reference.
			assertScope(EdeltaPackage.eINSTANCE.edeltaEcoreReference_Enamedelement,
			'''
			FooClass
			FooDataType
			FooEnum
			''')
	}

	@Test
	def void testScopeForEnamedElementInEcoreReferenceExpressionQualifiedEClass() {
		'''
		metamodel "foo"
		metamodel "bar"
		ecoreref foo.FooClass.
		'''.parseWithTestEcore.lastExpression.
			edeltaEcoreReferenceExpression.reference.
			assertScope(EdeltaPackage.eINSTANCE.edeltaEcoreReference_Enamedelement,
			'''
			myAttribute
			myReference
			''')
	}

//	@Test
//	def void testScopeForEClass() {
//		referenceToMetamodel.parseWithTestEcore.
//			assertScope(EdeltaPackage.eINSTANCE.edeltaEClassExpression_Eclass,
//			"FooClass")
//	}
//
//	@Test
//	def void testScopeForEDataType() {
//		referenceToMetamodel.parseWithTestEcore.
//			assertScope(EdeltaPackage.eINSTANCE.edeltaEDataTypeExpression_Edatatype,
//			"FooDataType")
//	}
//
//	@Test
//	def void testScopeForEAttribute() {
//		referenceToMetamodel.parseWithTestEcore.
//			assertScope(EdeltaPackage.eINSTANCE.edeltaEAttributeExpression_Eattribute,
//			"myAttribute")
//	}
//
//	@Test
//	def void testScopeForEReference() {
//		referenceToMetamodel.parseWithTestEcore.
//			assertScope(EdeltaPackage.eINSTANCE.edeltaEReferenceExpression_Ereference,
//			"myReference")
//	}
//
//	@Test
//	def void testScopeForEFeature() {
//		referenceToMetamodel.parseWithTestEcore.
//			assertScope(EdeltaPackage.eINSTANCE.edeltaEFeatureExpression_Efeature,
//			"myAttribute, myReference")
//	}
//
//	@Test
//	def void testScopeForCreateEClassPackage() {
//		createEClass.parseWithTestEcore.lastExpression.
//			assertScope(EdeltaPackage.eINSTANCE.edeltaEcoreCreateEClassExpression_Epackage,
//			"foo")
//	}
//
//	@Test
//	def void testScopeForReferenceToCreatedEClass() {
//		referenceToCreatedEClass.parseWithTestEcore.lastExpression.
//			assertScope(EdeltaPackage.eINSTANCE.edeltaEClassExpression_Eclass,
//			"NewClass, FooClass")
//		// NewClass is the one created in the program
//	}

	@Test
	def void testScopeForReferenceToCreatedEClassWithTheSameNameAsAnExistingEClass() {
		// our created EClass with the same name as an existing one must be
		// the one that is actually linked
		val prog = referenceToCreatedEClassWithTheSameNameAsAnExistingEClass.
			parseWithTestEcore
		val expressions = prog.main.expressions
		val eclassExp = expressions.last as EdeltaEcoreReferenceExpression
		assertSame(
			// the one created by the derived state computer
			prog.derivedStateLastEClass,
			eclassExp.reference.enamedelement
		)
	}

//	@Test
//	def void testScopeForReferenceToCreatedEAttribute() {
//		referenceToCreatedEAttribute.parseWithTestEcore.lastExpression.
//			assertScope(EdeltaPackage.eINSTANCE.edeltaEAttributeExpression_Eattribute,
//			"newAttribute, newAttribute2, myAttribute")
//		// newAttributes are the ones created in the program
//	}

	def private assertScope(EObject context, EReference reference, CharSequence expected) {
		expected.toString.assertEqualsStrings(
			context.getScope(reference).
				allElements.
				map[name].join("\n") + "\n"
		)
	}
}
