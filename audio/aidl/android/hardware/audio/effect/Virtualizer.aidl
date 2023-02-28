/*
 * Copyright (C) 2022 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package android.hardware.audio.effect;

import android.hardware.audio.effect.VendorExtension;
import android.media.audio.common.AudioChannelLayout;
import android.media.audio.common.AudioDeviceDescription;

/**
 * Virtualizer specific definitions. An audio virtualizer is a general name for an effect to
 * spatialize audio channels.
 *
 * All parameters defined in union Virtualizer must be gettable and settable. The capabilities
 * defined in Virtualizer.Capability can only acquired with IEffect.getDescriptor() and not
 * settable.
 */
@VintfStability
union Virtualizer {
    /**
     * Effect parameter tag to identify the parameters for getParameter().
     */
    @VintfStability
    union Id {
        int vendorExtensionTag;
        Virtualizer.Tag commonTag;
        SpeakerAnglesPayload speakerAnglesPayload;
    }

    /**
     * Vendor Virtualizer implementation definition for additional parameters.
     */
    VendorExtension vendor;

    /**
     * Payload to query speaker angles for the given channel position mask and device.
     * The Virtualizer implementation must return EX_ILLEGAL_ARGUMENT if the given payload not
     * supported.
     */
    @VintfStability
    parcelable SpeakerAnglesPayload {
        /**
         * Audio channel position definition. See
         * android.media.audio.common.AudioChannelLayout.aidl. Only the channel position "CHANNEL_*"
         * in AudioChannelLayout be used.
         */
        AudioChannelLayout layout;
        /**
         * Audio device type. See android.media.audio.common.AudioDeviceDescription.aidl.
         */
        AudioDeviceDescription device;
    }

    /**
     * Capability supported by Virtualizer implementation.
     */
    @VintfStability
    parcelable Capability {
        /**
         * Virtualizer capability extension, vendor can use this extension in case existing
         * capability definition not enough.
         */
        VendorExtension extension;
        /**
         * Maximum possible per mille strength.
         */
        int maxStrengthPm;
        /**
         * Indicates whether setting strength is supported. False value indicates only one strength
         * is supported and setParameter() method will always return EX_ILLEGAL_ARGUMENT.
         */
        boolean strengthSupported;
    }

    /**
     * The per mille strength of the virtualizer effect.
     *
     * If the implementation does not support per mille accuracy for setting the strength, it is
     * allowed to round the given strength to the nearest supported value. In this case {@link
     * #IEffect.getParameter()} method should return the rounded value that was actually set.
     *
     * The value of the strength must be non-negative and not exceed the value specified by
     * the 'maxStrengthPm' capability.
     */
    int strengthPm;

    /**
     * All angles are expressed in degrees and are relative to the listener.
     */
    @VintfStability
    parcelable ChannelAngle {
        /**
         * Audio channel layout, CHANNEL_* constants defined in
         * android.media.audio.common.AudioChannelLayout.
         */
        int channel;

        /**
         * 0 is the direction the listener faces, 180 is behind the listener, and -90 is left of
         * the listener.
         */
        int azimuthDegree;

        /**
         * 0 is the horizontal plane, +90 is above the listener, -90 is below.
         */
        int elevationDegree;
    }

    /**
     * Get only parameter.
     * A vector of angles per channel represented by azimuth and elevation (in degrees), client must
     * set Parameter.Id to SpeakerAnglesPayload to get speakerAngles.
     */
    ChannelAngle[] speakerAngles;

    /**
     * The audio device on which virtualzation mode is forced.
     */
    AudioDeviceDescription device;
}
