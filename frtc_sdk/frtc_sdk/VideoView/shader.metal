#include <metal_stdlib>

using namespace metal;

typedef struct {
    float4 position [[position]];
    float2 textureCoordinate;
} VertexOut;

vertex VertexOut 
ProcessVertex (constant float4 *vertexArray [[buffer(0)]],
               constant float2 *textureCoordinateArray [[buffer(1)]],
               unsigned int vertexID [[vertex_id]]) {

    VertexOut outputVertices;

    outputVertices.position = vertexArray[vertexID];
    outputVertices.textureCoordinate = textureCoordinateArray[vertexID];

    return outputVertices;
}

fragment float4 NV12Fragment(VertexOut inputFragment [[stage_in]],
                             texture2d<float> textureY [[texture(0)]],
                             texture2d<float> textureUV [[texture(1)]]) {
    constexpr sampler quadSampler;
    
    float y = textureY.sample(quadSampler, inputFragment.textureCoordinate).r;
    float u = textureUV.sample(quadSampler, inputFragment.textureCoordinate).r - 0.500;
    float v = textureUV.sample(quadSampler, inputFragment.textureCoordinate).g - 0.500;
    
    float r = y + 1.402 * v;
    float g = y - 0.344 * u - 0.714 * v;
    float b = y + 1.772 * u;
    
    return float4(r, g, b, 1.0);
}

fragment float4 I420Fragment(VertexOut inputFragment [[stage_in]],
                             texture2d<float> textureY [[texture(0)]],
                             texture2d<float> textureU [[texture(1)]],
                             texture2d<float> textureV [[texture(2)]]) {
    constexpr sampler quadSampler;
    
    float y = textureY.sample(quadSampler,inputFragment.textureCoordinate).r;
    float u = textureU.sample(quadSampler, inputFragment.textureCoordinate).r - 0.500;
    float v = textureV.sample(quadSampler, inputFragment.textureCoordinate).r - 0.500;
    
    float r = y + 1.402 * v;
    float g = y - 0.344 * u - 0.714 * v;
    float b = y + 1.772 * u;
    
    return float4(r, g, b, 1.0);
}
