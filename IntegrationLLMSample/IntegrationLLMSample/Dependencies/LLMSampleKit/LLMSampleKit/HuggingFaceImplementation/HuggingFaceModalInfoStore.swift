//
//  HuggingFaceModalInfoStorable.swift
//  
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

import Foundation
internal import MLXLLM
internal import MLXLMCommon
internal import MLXHuggingFace


class HuggingFaceModalInfoStore: ModelInfoStorable {
    enum ModalInfoStoreError: Error {
        case unstorable
    }

    func modelInfos() -> AsyncThrowingStream<ModelInfo, Error> {
        return AsyncThrowingStream { continuation in
            for configuration in LLMRegistry.customAll() {
                continuation.yield(ModelInfo(name: configuration.name, remoteURL: nil))
            }

            continuation.finish()
        }
    }

    func store(infos: [ModelInfo]) async throws {
        throw ModalInfoStoreError.unstorable
    }
}

fileprivate extension LLMRegistry {
    static func customAll() -> [ModelConfiguration] {
        [
            codeLlama13b4bit,
            deepSeekR1_7B_4bit,
            gemma2bQuantized,
            gemma_2_2b_it_4bit,
            gemma_2_9b_it_4bit,
            gemma3_1B_qat_4bit,
            gemma3n_E4B_it_lm_bf16,
            gemma3n_E2B_it_lm_bf16,
            gemma3n_E4B_it_lm_4bit,
            gemma3n_E2B_it_lm_4bit,
            gemma4_e4b_it_4bit,
            gemma4_e2b_it_4bit,
            granite3_3_2b_4bit,
            granite_4_0_h_tiny_4bit_dwq,
            llama3_1_8B_4bit,
            llama3_2_1B_4bit,
            llama3_2_3B_4bit,
            llama3_8B_4bit,
            mistral7B4bit,
            mistralNeMo4bit,
            openelm270m4bit,
            phi3_5MoE,
            phi3_5_4bit,
            phi4bit,
            qwen205b4bit,
            qwen2_5_7b,
            qwen2_5_1_5b,
            qwen3_0_6b_4bit,
            qwen3_1_7b_4bit,
            qwen3_4b_4bit,
            qwen3_8b_4bit,
            qwen3MoE_30b_a3b_4bit,
            smolLM_135M_4bit,
            deepseek_r1_4bit,
            mimo_7b_sft_4bit,
            glm4_9b_4bit,
            acereason_7b_4bit,
            bitnet_b1_58_2b_4t_4bit,
            smollm3_3b_4bit,
            ernie_45_0_3BPT_bf16_ft,
            lfm2_1_2b_4bit,
            baichuan_m1_14b_instruct_4bit,
            exaone_4_0_1_2b_4bit,
            lille_130m_bf16,
            olmoe_1b_7b_0125_instruct_4bit,
            olmo_2_1124_7B_Instruct_4bit,
            ling_mini_2_2bit,
            lfm2_8b_a1b_3bit_mlx,
            nanochat_d20_mlx,
            gpt_oss_20b_MXFP4_Q8,
            jamba_3b,
        ]
    }
}
