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

#pragma once

#include <aidl/android/hardware/audio/effect/BnEffect.h>
#include <fmq/AidlMessageQueue.h>
#include <cstdlib>
#include <memory>

#include "effect-impl/EffectImpl.h"
#include "effect-impl/EffectUUID.h"

namespace aidl::android::hardware::audio::effect {

class AcousticEchoCancelerSwContext final : public EffectContext {
  public:
    AcousticEchoCancelerSwContext(int statusDepth, const Parameter::Common& common)
        : EffectContext(statusDepth, common) {
        LOG(DEBUG) << __func__;
    }

    RetCode setEchoDelay(int echoDelayUs);
    int getEchoDelay() const { return mEchoDelayUs; }

  private:
    int mEchoDelayUs;
};

class AcousticEchoCancelerSw final : public EffectImpl {
  public:
    static const std::string kEffectName;
    static const bool kStrengthSupported;
    static const AcousticEchoCanceler::Capability kCapability;
    static const Descriptor kDescriptor;
    AcousticEchoCancelerSw() { LOG(DEBUG) << __func__; }
    ~AcousticEchoCancelerSw() {
        cleanUp();
        LOG(DEBUG) << __func__;
    }

    ndk::ScopedAStatus getDescriptor(Descriptor* _aidl_return) override;
    ndk::ScopedAStatus setParameterSpecific(const Parameter::Specific& specific) override;
    ndk::ScopedAStatus getParameterSpecific(const Parameter::Id& id,
                                            Parameter::Specific* specific) override;

    std::shared_ptr<EffectContext> createContext(const Parameter::Common& common) override;
    std::shared_ptr<EffectContext> getContext() override;
    RetCode releaseContext() override;

    std::string getEffectName() override { return kEffectName; };
    IEffect::Status effectProcessImpl(float* in, float* out, int samples) override;

  private:
    std::shared_ptr<AcousticEchoCancelerSwContext> mContext;
    ndk::ScopedAStatus getParameterAcousticEchoCanceler(const AcousticEchoCanceler::Tag& tag,
                                                        Parameter::Specific* specific);
};
}  // namespace aidl::android::hardware::audio::effect
