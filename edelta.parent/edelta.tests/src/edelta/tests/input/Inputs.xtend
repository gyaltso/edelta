package edelta.tests.input

class Inputs {
	def referenceToMetamodel() {
		'''
			metamodel "foo"
		'''
	}

	def referencesToMetamodels() {
		'''
			metamodel "foo"
			metamodel "bar"
		'''
	}

	def referenceToEPackage() {
		'''
			metamodel "foo"
			
			ecoreref(foo)
		'''
	}

	def referenceToEClass() {
		'''
			metamodel "foo"
			
			ecoreref(FooClass)
		'''
	}

	def referenceToEDataType() {
		'''
			metamodel "foo"
			
			ecoreref(FooDataType)
		'''
	}

	def referenceToEEnum() {
		'''
			metamodel "foo"
			
			ecoreref(FooEnum)
		'''
	}

	def referenceToEAttribute() {
		'''
			metamodel "foo"
			
			ecoreref(myAttribute)
		'''
	}

	def referenceToEReference() {
		'''
			metamodel "foo"
			
			ecoreref(myReference)
		'''
	}

	def referenceToEEnumLiteral() {
		'''
			metamodel "foo"
			
			ecoreref(FooEnumLiteral)
		'''
	}

	def useImportedJavaTypes() {
		'''
		import java.util.List

		package foo;
		
		def bar(List<String> s) {
			s.empty
		}
		'''
	}

	def operationWithInferredReturnType() {
		'''
		package foo;
		
		def bar(String s) {
			s.empty
		}
		'''
	}

	def operationWithReturnType() {
		'''
		package foo;
		
		def bar(String s) : boolean {
			s.empty
		}
		'''
	}

	def operationAccessingLib() {
		'''
		package foo;
		
		def bar(String s) {
			newEClass(s)
		}
		'''
	}

	def operationNewEClassWithInitializer() {
		'''
		package foo;
		
		def bar(String s) {
			newEClass(s) [
				ESuperTypes += newEClass("Base")
			]
		}
		'''
	}

	def referenceToCreatedEClass() {
		'''
			metamodel "foo"
			
			createEClass NewClass in foo {}
			ecoreref(NewClass)
		'''
	}

	def createEClassAndReferenceToExistingEDataType() {
		'''
			metamodel "foo"
			
			createEClass NewClass in foo {}
			ecoreref(FooDataType)
		'''
	}

	def createEClassAndReferenceToExistingEDataTypeFullyQualified() {
		'''
			metamodel "foo"
			
			createEClass NewClass in foo {}
			ecoreref(foo.FooDataType)
		'''
	}

	def referenceToCreatedEClassWithTheSameNameAsAnExistingEClass() {
		'''
			metamodel "foo"
			
			createEClass FooClass in foo {}
			ecoreref(FooClass)
		'''
	}

	def referenceToChangedEClassWithTheSameNameAsAnExistingEClass() {
		'''
			metamodel "foo"
			
			changeEClass foo.FooClass {}
			ecoreref(FooClass)
		'''
	}

	def referenceToChangedEClassWithANewName() {
		'''
			metamodel "foo"
			
			changeEClass foo.FooClass newName RenamedClass {
				createEAttribute anotherAttr type FooDataType {
				}
			}
			ecoreref(RenamedClass)
		'''
	}

	def referenceToChangedEClassCopiedAttribute() {
		'''
			metamodel "foo"
			
			changeEClass foo.FooClass {
				val attr = ecoreref(FooClass.myAttribute)
			}
		'''
	}

	def referenceToCreatedEAttributeSimple() {
		'''
			metamodel "foo"
			
			createEClass NewClass in foo {
				createEAttribute newAttribute type FooDataType {}
				createEAttribute newAttribute2 type FooDataType {}
			}
			ecoreref(newAttribute)
		'''
	}

	def referenceToCreatedEAttributeRenamed() {
		'''
			metamodel "foo"
			
			createEClass NewClass in foo {
				createEAttribute newAttribute type FooDataType {
					name = "changed"
				}
				createEAttribute newAttribute2 type FooDataType {}
			}
			ecoreref(newAttribute)
			ecoreref(changed)
		'''
	}

	def referenceToCreatedEAttributeRenamedInChangedEClass() {
		'''
			metamodel "foo"
			
			changeEClass foo.FooClass {
				createEAttribute newAttribute type FooDataType {
					name = "changed"
				}
			}
			ecoreref(newAttribute)
			ecoreref(changed)
		'''
	}

	def referenceToCreatedEClassRenamed() {
		'''
			metamodel "foo"
			
			createEClass NewClass in foo {
				name = "changed"
			}
			ecoreref(NewClass)
			ecoreref(changed)
		'''
	}

	def referenceToChangedEClassRenamed() {
		'''
			metamodel "foo"
			
			changeEClass foo.FooClass {
				name = "changed"
			}
			ecoreref(FooClass)
			ecoreref(changed)
		'''
	}

	def useAsCustomEdeltaCreatingEClass() {
		'''
			import edelta.tests.additional.MyCustomEdelta
			
			metamodel "foo"
			
			use MyCustomEdelta as my
			
			modifyEcore aTest epackage foo {
				my.createANewEAttribute(
					my.createANewEClass)
			}
		'''
	}

	def useAsCustomEdeltaAsExtensionCreatingEClass() {
		'''
			import edelta.tests.additional.MyCustomEdelta
			
			metamodel "foo"
			
			use MyCustomEdelta as extension my
			
			modifyEcore aTest epackage foo {
				createANewEClass.createANewEAttribute
			}
		'''
	}

	def useAsCustomStatefulEdeltaCreatingEClass() {
		'''
			import edelta.tests.additional.MyCustomStatefulEdelta
			
			metamodel "foo"
			
			use MyCustomStatefulEdelta as my
			
			modifyEcore aTest epackage foo {
				my.createANewEAttribute(
					my.createANewEClass)
			}
		'''
	}

	def createEClassStealingAttribute() {
		'''
			metamodel "foo"
			
			modifyEcore aTest epackage foo {
				addNewEClass("NewClass") [
					addEAttribute(ecoreref(FooClass.myAttribute))
				]
			}
		'''
	}

	def changeEClassRemovingAttribute() {
		'''
			metamodel "foo"
			
			changeEClass foo.FooClass {
				val attr = ecoreref(FooClass.myAttribute)
				EStructuralFeatures -= attr
			}
		'''
	}

	def createEClassAndAddEAttributeUsingLibMethodAndReference() {
		'''
			metamodel "foo"
			
			createEClass NewClass in foo {
				EStructuralFeatures += newEAttribute("newTestAttr") [
					EType = ecoreref(FooDataType)
				]
			}
			
			ecoreref(newTestAttr)
		'''
	}

	def createEClassUsingLibMethods() {
		'''
		import org.eclipse.emf.ecore.EClass

		metamodel "foo"

		createEClass ANewClass in foo {
			addNewEAttribute("ANewAttribute", ecoreref(FooDataType)) [
				lowerBound = 1
			]
			addNewEReference("ANewReference", ecoreref(FooClass)) [
				lowerBound = 1
			]
			// the containing EPackage
			getEPackage => [
				addNewEEnum("ANewEnum") [
					addNewEEnumLiteral("ANewEnumLiteral") [
						value = 10
					]
				]
				addNewEDataType("ANewDataType", "java.lang.String")
			]
			ecoreref(ANewClass)
			ecoreref(ANewClass.ANewAttribute)
			ecoreref(ANewClass.ANewReference)
			ecoreref(ANewEnum)
			ecoreref(ANewEnum.ANewEnumLiteral)
			ecoreref(ANewDataType)
		}
		'''
	}

	def modifyEcoreUsingLibMethods() {
		'''
		import org.eclipse.emf.ecore.EClass

		metamodel "foo"

		modifyEcore aTest epackage foo {
			addNewEClass("ANewClass") [
				addNewEAttribute("ANewAttribute", ecoreref(FooDataType)) [
					lowerBound = 1
				]
				addNewEReference("ANewReference", ecoreref(FooClass)) [
					lowerBound = 1
				]
			]
			addNewEEnum("ANewEnum") [
				addNewEEnumLiteral("ANewEnumLiteral") [
					value = 10
				]
			]
			addNewEDataType("ANewDataType", "java.lang.String")
			ecoreref(ANewClass)
			ecoreref(ANewClass.ANewAttribute)
			ecoreref(ANewClass.ANewReference)
			ecoreref(ANewEnum)
			ecoreref(ANewEnum.ANewEnumLiteral)
			ecoreref(ANewDataType)
		}
		'''
	}

	def personListExampleModifyEcore()
	'''
		import edelta.refactorings.lib.EdeltaRefactorings
		
		// IMPORTANT: ecores must be in a source directory
		// otherwise you can't refer to them
		package edelta.personlist.example
		
		metamodel "PersonList"
		metamodel "ecore"
		
		use EdeltaRefactorings as extension refactorings
		
		modifyEcore improvePerson epackage PersonList {
			ecoreref(PersonList.Person) => [
				// since 'refactorings' is an 'extension'
				// we use its method as an extension method
				introduceSubclasses(
					ecoreref(Person.gender),
					ecoreref(Gender)
				)
				addEAttribute(
					refactorings.mergeAttributes("name",
						ecoreref(Person.firstname).EAttributeType,
						#[ecoreref(Person.firstname), ecoreref(Person.lastname)]
					)
				)
			]
		}
		
		modifyEcore introducePlace epackage PersonList {
			addNewEClass("Place") [
				abstract = true
				extractIntoSuperclass(#[ecoreref(LivingPlace.address), ecoreref(WorkPlace.address)])
			]
		}
		
		modifyEcore introduceWorkingPosition epackage PersonList {
			addNewEClass("WorkingPosition") [
				EStructuralFeatures += newEAttribute("description") [
					EType = ecoreref(EString)
				]
				extractMetaClass(ecoreref(Person.works), "position", "works")
			]
		}
		
		modifyEcore improveList epackage PersonList {
			ecoreref(PersonList.List).addEReference(
				refactorings.mergeReferences("places",
					ecoreref(Place),
					#[ecoreref(List.wplaces), ecoreref(List.lplaces)]
				)
			)
		}
		
	'''
}
