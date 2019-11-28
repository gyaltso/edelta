/*
 * generated by Xtext 2.10.0
 */
package edelta.validation

import com.google.inject.Inject
import edelta.edelta.EdeltaEcoreReferenceExpression
import edelta.edelta.EdeltaUseAs
import edelta.lib.AbstractEdelta
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.JvmVoid
import org.eclipse.xtext.diagnostics.Diagnostic
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.xbase.XMemberFeatureCall
import org.eclipse.xtext.xbase.XbasePackage
import org.eclipse.xtext.xbase.typesystem.IBatchTypeResolver
import org.eclipse.xtext.xbase.typesystem.internal.FeatureLinkHelper
import org.eclipse.xtext.xbase.typesystem.references.StandardTypeReferenceOwner
import org.eclipse.xtext.xbase.typesystem.util.CommonTypeComputationServices

import static edelta.edelta.EdeltaPackage.Literals.*

/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class EdeltaValidator extends AbstractEdeltaValidator {

	public static val PREFIX = "edelta.";
	public static val TYPE_MISMATCH = PREFIX + "TypeMismatch";
	public static val INTERPRETER_TIMEOUT = PREFIX + "InterpreterTimeout";

	@Inject CommonTypeComputationServices services
	@Inject extension IBatchTypeResolver
	@Inject extension FeatureLinkHelper

	@Check
	def void checkValidUseAs(EdeltaUseAs useAs) {
		if (!isConformant(useAs, AbstractEdelta, useAs.type)) {
			error(
				"Not a valid type: must be an " + AbstractEdelta.name,
				EDELTA_USE_AS__TYPE,
				TYPE_MISMATCH
			)
		} else {
			val type = useAs.type.type
			if (type instanceof JvmGenericType) {
				// otherwise it's a JvmVoid, which means, unresolved
				// and an error is issued by other validators
				if (type.isAbstract) {
					error(
						"Cannot be an abstract type",
						EDELTA_USE_AS__TYPE,
						TYPE_MISMATCH
					)
				}
			}
		}
	}

	/**
	 * This explicit check is required since we disabled the
	 * default checks in {@link EdeltaLinkingDiagnosticMessageProvider}
	 */
	@Check
	def void checkXMemberFeatureCall(XMemberFeatureCall e) {
		val feature = e.feature
		if (!(feature instanceof JvmVoid))
			return // nothing to check
		val receiver = e.memberCallTarget
		if (receiver instanceof EdeltaEcoreReferenceExpression) {
			val types = receiver.resolveTypes
			val receiverType = (types).getActualType(receiver)
			val args = e.syntacticArguments
				.map[types.getActualType(it)]
				.join(", ", [humanReadableName])
			var msg = '''The method or field «e.concreteSyntaxFeatureName»(«args») is undefined for the type «receiverType.humanReadableName»'''
			error(
				msg,
				XbasePackage.Literals.XABSTRACT_FEATURE_CALL__FEATURE,
				Diagnostic.LINKING_DIAGNOSTIC
			)
		}
	}

	def isConformant(EObject context, Class<?> expected, JvmTypeReference actual) {
		val actualType = actual.toLightweightTypeReference(context)
		actualType.isSubtypeOf(expected)
	}

	def toLightweightTypeReference(JvmTypeReference typeRef, EObject context) {
		return newTypeReferenceOwner(context).toLightweightTypeReference(typeRef)
	}

	def protected newTypeReferenceOwner(EObject context) {
		return new StandardTypeReferenceOwner(services, context);
	}
}
