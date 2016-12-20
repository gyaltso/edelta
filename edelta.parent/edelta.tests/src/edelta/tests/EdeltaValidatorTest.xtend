/*
 * generated by Xtext 2.10.0
 */
package edelta.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(EdeltaInjectorProvider)
class EdeltaValidatorTest extends EdeltaAbstractTest {

	@Test
	def void testCanReferToEcoreMetamodel() {
		'''
			metamodel "http://www.eclipse.org/emf/2002/Ecore"
		'''.parse.assertNoErrors
	}

	@Test
	def void testCanReferToEClass() {
		'''
			metamodel "http://www.eclipse.org/emf/2002/Ecore"
			
			eclass EClass
		'''.parse.assertNoErrors
	}

}
