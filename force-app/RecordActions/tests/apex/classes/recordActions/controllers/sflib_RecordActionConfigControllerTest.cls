/**
 * sflib_RecordActionConfigControllerTest
 *
 * Unit test class for sflib_RecordActionConfigController
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
 *
 * @see sflib_RecordActionConfigController
 */
@IsTest
private class sflib_RecordActionConfigControllerTest {

    @IsTest
    static void testGetConfig_returnsFalseWhenSettingIsMissing() {
        // GIVEN no custom setting record exists

        // WHEN reading config
        System.Test.startTest();
        sflib_RecordActionSettings result =
                sflib_RecordActionConfigController.getConfig();
        System.Test.stopTest();

        // THEN the default is false
        System.Assert.isNotNull(result);
        System.Assert.areEqual(false, result.historyLog);
    }

    @IsTest
    static void testGetConfig_returnsFalseWhenSettingIsMissing_failing() {
        // GIVEN no custom setting record exists

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        sflib_RecordActionSettings settingsMock = (sflib_RecordActionSettings) mocks.mock(sflib_RecordActionSettings.class);

        mocks.startStubbing();
        mocks.when(settingsMock.get()).thenThrow(new DmlException());
        mocks.stopStubbing();

        sflib_RecordActionSettings.replaceWith(settingsMock);

        // WHEN reading config
        System.Test.startTest();
        try {
            sflib_RecordActionConfigController.getConfig();
            System.Assert.fail('Expected an exception');
        } catch (Exception e) {
            System.Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        System.Test.stopTest();
    }

    @IsTest
    static void testGetConfig_returnsStoredValue() {
        // GIVEN an org default custom setting record
        insert new sflib_RecordActionConfig__c(
                SetupOwnerId = UserInfo.getOrganizationId(),
                HistoryLog__c = true
        );

        // WHEN reading config
        System.Test.startTest();
        sflib_RecordActionSettings result =
                sflib_RecordActionConfigController.getConfig();
        System.Test.stopTest();

        // THEN the stored value is returned
        System.Assert.isNotNull(result);
        System.Assert.areEqual(true, result.historyLog);
    }

    @IsTest
    static void testSaveConfig_insertsNewSetting() {
        // GIVEN a settings payload
        sflib_RecordActionSettings input =
                sflib_RecordActionSettings.newInstance();
        input.historyLog = true;

        // WHEN saving config
        System.Test.startTest();
        sflib_RecordActionConfigController.saveConfig(input);
        System.Test.stopTest();

        // THEN the setting is persisted
        sflib_RecordActionConfig__c saved = sflib_RecordActionConfig__c.getInstance();
        System.Assert.isNotNull(saved);
        System.Assert.areEqual(true, saved.HistoryLog__c);
    }

    @IsTest
    static void testSaveConfig_insertsNewSetting_failing() {

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        sflib_RecordActionSettings settingsMock = (sflib_RecordActionSettings) mocks.mock(sflib_RecordActionSettings.class);

        mocks.startStubbing();
        mocks.when(settingsMock.save()).thenThrow(new DmlException());
        mocks.stopStubbing();

        sflib_RecordActionSettings.replaceWith(settingsMock);

        // WHEN saving config
        System.Test.startTest();
        try {
            sflib_RecordActionConfigController.saveConfig(settingsMock);
            System.Assert.fail('Expected an exception, but got none');
        } catch (Exception e) {
            System.Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        System.Test.stopTest();
    }

    @IsTest
    static void testSaveConfig_updatesExistingSetting() {
        // GIVEN an existing org default custom setting record
        insert new sflib_RecordActionConfig__c(
                SetupOwnerId = UserInfo.getOrganizationId(),
                HistoryLog__c = false
        );

        sflib_RecordActionSettings input =
                sflib_RecordActionSettings.newInstance();
        input.historyLog = true;

        // WHEN saving config
        System.Test.startTest();
        sflib_RecordActionConfigController.saveConfig(input);
        System.Test.stopTest();

        // THEN the setting is updated
        sflib_RecordActionConfig__c saved = sflib_RecordActionConfig__c.getInstance();
        System.Assert.isNotNull(saved);
        System.Assert.areEqual(true, saved.HistoryLog__c);
    }
}