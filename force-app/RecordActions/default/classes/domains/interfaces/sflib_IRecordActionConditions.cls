/**
 * sflib_IRecordActionConditions domain interface
 *
 * This domain interface defines the public accessible methods for the sflib_RecordActionConditions
 * domain which is a wrapper around `sflib_RecordActionCondition__c` records,
 * containing getter, setter and filter (selector) methods
 *
 * When method accept or return objects (DTOs) then these should be publicly
 * accessible (avoid using sub-classes located in implementations)
 *
 * @author architect ir. Wilhelmus G.J. Velzeboer
 *
 * Copyright (c), W.G.J. Velzeboer,
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above author notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the author nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * @see sflib_RecordActionConditions
 */
public interface sflib_IRecordActionConditions extends fflib_ISObjects2
{
	/**
	 * Get the `sflib_RecordActionCondition__c` records the domain contains
	 *
	 * @return Returns the list of `sflib_RecordActionCondition__c` records
	 *
	 * @see sflib_RecordActionCondition__c
	 *
	 * @example
	 * List<sflib_RecordActionCondition__c> filteredRecordActionConditions =
	 *         RecordActionConditions.newInstance(recordIds)
	 *                 .selectBySomeField('Holland')
	 *                 .getRecordActionConditions();
	 */
	List<sflib_RecordActionCondition__c> getRecordActionConditions();

	/**
	 * Get the `sflib_RecordActionCondition__c` records by their Id
	 *
	 * @return Returns a map of the `sflib_RecordActionCondition__c` record by its `sflib_RecordActionCondition__c.Id`
	 *
	 * @see sflib_RecordActionCondition__c
	 *
	 * @example
	 * Map<Id, sflib_RecordActionCondition__c> recordActionConditionsById =
	 *         sflib_RecordActionConditions.newInstance(recordIds)
	 *                 .getById();
	 */
	Map<Id, sflib_RecordActionCondition__c> getById();

	/**
	 * Gets a sub-selection of the `sflib_RecordActionCondition__c` records matching the given ids
	 *
	 * @param ids A set of `sflib_RecordActionCondition__c.Id` values
	 *
	 * @return Returns a new instance of the sflib_RecordActionConditions domain containing the matching records
	 *
	 * @example sflib_IRecordActionConditions subset = recordActionConditions.selectById(recordIds);
	 */
	sflib_IRecordActionConditions selectById(Set<Id> ids);
}
